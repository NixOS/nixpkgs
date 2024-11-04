let
  sdkVersions = builtins.fromJSON (builtins.readFile ./metadata/versions.json);
in

{
  lib,
  stdenv,
  stdenvNoCC,
  substitute,

  # Specifies the major version used for the SDK. Uses `hostPlatform.darwinSdkVersion` by default.
  darwinSdkMajorVersion ? (
    if lib.versionOlder stdenv.hostPlatform.darwinSdkVersion "11" then
      lib.versions.majorMinor stdenv.hostPlatform.darwinSdkVersion
    else
      lib.versions.major stdenv.hostPlatform.darwinSdkVersion
  ),
  # Enabling bootstrap disables propagation. Defaults to `false` (meaning to propagate certain packages and `xcrun`)
  # except in stage0 of the Darwin stdenv bootstrap.
  enableBootstrap ? stdenv.name == "bootstrap-stage0-stdenv-darwin",

  # Required by various phases
  callPackage,
  jq,
}:

let
  sdkInfo =
    sdkVersions.${darwinSdkMajorVersion}
      or (lib.throw "Unsupported SDK major version: ${darwinSdkMajorVersion}");
  sdkVersion = sdkInfo.version;

  fetchSDK = callPackage ./common/fetch-sdk.nix { };

  phases = lib.composeManyExtensions (
    [
      (callPackage ./common/add-core-symbolication.nix { })
      (callPackage ./common/derivation-options.nix { })
      (callPackage ./common/passthru-private-frameworks.nix { inherit sdkVersion; })
      (callPackage ./common/passthru-source-release-files.nix { inherit sdkVersion; })
      (callPackage ./common/remove-disallowed-packages.nix { })
    ]
    # Only process stubs and convert them to tbd-v4 if jq is available. This can be made unconditional once
    # the bootstrap tools have jq and libtapi.
    ++ lib.optional (jq != null) (callPackage ./common/process-stubs.nix { })
    # Avoid infinite recursions by not propagating certain packages, so they can themselves build with the SDK.
    ++ lib.optionals (!enableBootstrap) [
      (callPackage ./common/propagate-inputs.nix { })
      (callPackage ./common/propagate-xcrun.nix { })
    ]
    ++ [
      # These have to happen last.
      (callPackage ./common/rewrite-sdk-paths.nix { inherit sdkVersion; })
      (callPackage ./common/run-build-phase-hooks.nix { })
    ]
  );
in
stdenvNoCC.mkDerivation (
  lib.extends phases (finalAttrs: {
    pname = "apple-sdk";
    inherit (sdkInfo) version;

    src = fetchSDK sdkInfo;

    dontConfigure = true;

    strictDeps = true;

    setupHooks = [
      # `role.bash` is copied from `../build-support/setup-hooks/role.bash` due to the requirements not to reference
      # paths outside the package when it is in `by-name`.  It needs to be kept in sync, but it fortunately does not
      # change often. Once `build-support` is available as a package (or some other mechanism), it should be changed
      # to whatever that replacement is.
      ./setup-hooks/role.bash
      (substitute {
        src = ./setup-hooks/sdk-hook.sh;
        substitutions = [
          "--subst-var-by"
          "sdkVersion"
          (lib.escapeShellArgs (lib.splitVersion sdkVersion))
        ];
      })
    ];

    installPhase =
      let
        sdkName = "MacOSX${lib.versions.majorMinor sdkVersion}.sdk";
        sdkMajor = lib.versions.major sdkVersion;
      in
      ''
        runHook preInstall

        mkdir -p "$sdkpath"

        cp -rd . "$sdkpath/${sdkName}"
        ${lib.optionalString (lib.versionAtLeast finalAttrs.version "11.0") ''
          ln -s "${sdkName}" "$sdkpath/MacOSX${sdkMajor}.sdk"
        ''}
        ln -s "${sdkName}" "$sdkpath/MacOSX.sdk"

        runHook postInstall
      '';

    passthru = {
      sdkroot = finalAttrs.finalPackage + "/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
    };

    __structuredAttrs = true;

    meta = {
      description = "Frameworks and libraries required for building packages on Darwin";
      homepage = "https://developer.apple.com";
      maintainers = lib.teams.darwin.members;
      platforms = lib.platforms.darwin;
      badPlatforms =
        lib.optionals (lib.versionAtLeast sdkVersion "10.15") [ lib.systems.inspect.patterns.is32bit ]
        ++ lib.optionals (lib.versionOlder sdkVersion "11.0") [ lib.systems.inspect.patterns.isAarch ];
    };
  })
)

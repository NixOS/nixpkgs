{
  callPackage,
  runCommand,
  lib,
  stdenv,
}:
let
  src = callPackage ./src.nix { };
  inherit (src)
    packageVersion
    firefoxVersion
    firefox
    source
    ;

  versionComponents = lib.strings.splitString "-" src.packageVersion;
  release = builtins.elemAt versionComponents 1;

  localSettingsPrefs = runCommand "local-settings.js" { } ''
    # Import of `librewolf.cfg` file is already being done manually.
    substitute ${source}/settings/defaults/pref/local-settings.js $out \
      --replace-fail 'pref("general.config.filename", "librewolf.cfg");' ""
  '';

  extraPrefsFiles = [
    "${source}/settings/librewolf.cfg"
    localSettingsPrefs
  ];

  extraPoliciesFiles = [ "${source}/settings/distribution/policies.json" ];
in
{
  inherit packageVersion;

  srcs = [
    firefox
    source
  ];

  extraPostUnpack = ''
    chmod -R u+w -- "${source.name}"
    # This layout is required for the patch script to work
    mv firefox-${firefoxVersion} ${source.name}/librewolf-${packageVersion}
    chmod -R u+w -- "$sourceRoot"
  '';

  sourceRoot = "${source.name}/librewolf-${packageVersion}";

  extraConfigureFlags = [
    "--with-unsigned-addon-scopes=app,system"
    "--disable-default-browser-agent"
    # Flags based on discussion in https://github.com/NixOS/nixpkgs/issues/482250
    "--disable-debug"
    "--disable-debug-symbols"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--enable-lto=thin,cross"
  ];

  extraPreConfigure = ''
    export MOZ_TELEMETRY_REPORTING=
    export MOZ_PKG_VERSION=${packageVersion}
  '';

  extraPostPatch = ''
    patchShebangs --build ../scripts
    SKIP_FETCHING_LOCALES=1 ../scripts/patch.sh ${firefoxVersion} ${release}
    # We set the parameters in build-mozilla-mach instead
    rm mozconfig
  '';

  inherit localSettingsPrefs extraPrefsFiles extraPoliciesFiles;

  extraPassthru = {
    librewolf = {
      inherit src;
    };
    inherit extraPrefsFiles extraPoliciesFiles;
  };
}

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  writeShellScriptBin,
  zig_0_15,
  nix-update-script,
  apple-sdk,
  cctools,
}:

let
  useDarwinSdkTools = stdenv.buildPlatform.isDarwin && stdenv.hostPlatform.isDarwin;
  darwinSdkRoot = "${apple-sdk}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
  darwinDeveloperDir = "${apple-sdk}/Platforms/MacOSX.platform/Developer";
  darwinXcodeSelect = writeShellScriptBin "xcode-select" ''
    if [ "$1" = "--print-path" ]; then
      echo ${lib.escapeShellArg darwinDeveloperDir}
      exit 0
    fi
    echo "unsupported xcode-select invocation: $*" >&2
    exit 1
  '';
  darwinXcrun = writeShellScriptBin "xcrun" ''
    if [ "$1" = "--sdk" ] && [ "$3" = "--show-sdk-path" ]; then
      echo ${lib.escapeShellArg darwinSdkRoot}
      exit 0
    fi
    echo "unsupported xcrun invocation: $*" >&2
    exit 1
  '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "herdr";
  version = "0.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ogulcancelik";
    repo = "herdr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DjCSwhRMBRE9lSvjpX6m8IpoEgUbOP1jcmeXMlQlSQY=";
  };

  cargoHash = "sha256-NHVSdXlGsqhI/Mij28TvdW0f6IKOglNgpBNb2sFXocI=";

  zigDeps = zig_0_15.fetchDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/vendor/libghostty-vt";
    fetchAll = true;
    hash = "sha256-pgGu8+NwvFcj6SrN4VaTHLeHdA7QY731ctyrHZwgFAc=";
  };

  nativeBuildInputs = [
    zig_0_15.hook
  ]
  ++ lib.optionals useDarwinSdkTools [
    cctools
    darwinXcodeSelect
    darwinXcrun
  ];

  env = lib.optionalAttrs useDarwinSdkTools {
    SDKROOT = darwinSdkRoot;
  };

  # Upstream binary tests are renamed, added, or changed between releases and
  # depend on host process details, so Nix-only patches for them are brittle.
  doCheck = false;

  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  postConfigure = ''
    export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
    cp -rL ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
    chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Agent multiplexer that lives in your terminal";
    homepage = "https://github.com/ogulcancelik/herdr";
    changelog = "https://github.com/ogulcancelik/herdr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ kevinpita ];
    mainProgram = "herdr";
    platforms = lib.platforms.unix;
  };
})

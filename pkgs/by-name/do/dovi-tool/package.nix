{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  makeFontsConf,
  versionCheckHook,
  nix-update-script,
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [ ];
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dovi-tool";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = "dovi_tool";
    tag = finalAttrs.version;
    hash = "sha256-CsF/KgY4D2pBXYzm6FtJt2xo7mSLt3JGkvajRYA4MWA=";
  };

  cargoHash = "sha256-21tb45F66yR5rquWML22EAPsExOkmas6Yquq9vEmhdk=";

  nativeBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    pkg-config
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    fontconfig
  ];

  preCheck = lib.optionals (!stdenv.isDarwin) ''
    # Fontconfig error: Cannot load default config file: No such file: (null)
    export FONTCONFIG_FILE="${fontsConf}"
    # Fontconfig error: No writable cache directories
    export XDG_CACHE_HOME="$(mktemp -d)"
  '';

  # Needed for rpu::plot::plot_p7 to pass in the sandbox.
  __impureHostDeps = lib.optionals stdenv.isDarwin [
    "/System/Library/Fonts/Supplemental/Arial.ttf"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/dovi_tool";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool combining multiple utilities for working with Dolby Vision";
    homepage = "https://github.com/quietvoid/dovi_tool";
    changelog = "https://github.com/quietvoid/dovi_tool/releases/tag/${finalAttrs.version}";
    mainProgram = "dovi_tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ plamper ];
  };
})

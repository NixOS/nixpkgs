{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  makeFontsConf,
  versionCheckHook,
  writeShellApplication,
  libdovi,
  nixVersions,
  nix-update,
  tomlq,
}:

let
  fontsConf = makeFontsConf {
    fontDirectories = [ ];
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dovi-tool";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = "dovi_tool";
    tag = finalAttrs.version;
    hash = "sha256-4C9d8Rt1meV6Pcdnf2SaiWGA97sRj2WmvKsf1rC01Bs=";
  };

  cargoHash = "sha256-Dg6IDcYm3qTSyE5kVgZ8Yka8538KDFyBN+weUyAfQT8=";

  nativeBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    pkg-config
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    fontconfig
  ];

  preCheck = lib.optionals (!stdenv.hostPlatform.isDarwin) ''
    # Fontconfig error: Cannot load default config file: No such file: (null)
    export FONTCONFIG_FILE="${fontsConf}"
    # Fontconfig error: No writable cache directories
    export XDG_CACHE_HOME="$(mktemp -d)"
  '';

  # Needed for rpu::plot::plot_p7 to pass in the sandbox.
  __impureHostDeps = lib.optionals stdenv.hostPlatform.isDarwin [
    "/System/Library/Fonts/Supplemental/Arial.ttf"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/dovi_tool";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-${finalAttrs.pname}";
    runtimeInputs = [
      nixVersions.latest
      nix-update
      tomlq
    ];

    text = ''
      nix-update ${finalAttrs.pname}
      src="$(nix eval -f . --raw ${finalAttrs.pname}.src)"
      libver="$(tq -f "$src/dolby_vision/Cargo.toml" package.version)"
      nix-update ${libdovi.pname} --version "$libver"
    '';
  });

  meta = {
    description = "CLI tool combining multiple utilities for working with Dolby Vision";
    homepage = "https://github.com/quietvoid/dovi_tool";
    changelog = "https://github.com/quietvoid/dovi_tool/releases/tag/${finalAttrs.version}";
    mainProgram = "dovi_tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ plamper ];
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "impala";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cxgPFLg//fwsPehyIhhP8AQLRnM3KQ8Th7+BpGlJfi8=";
  };

  cargoHash = "sha256-URReJVoE4CN+utSX58nbfhJxClWLbCvWFLgYF00JXWg=";

  # fix for compilation of musl builds on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nydragon
      saadndm
    ];
    mainProgram = "impala";
  };
})

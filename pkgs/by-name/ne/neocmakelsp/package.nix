{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
  rustPlatform,
  rustc,
  cargo,
}:

stdenv.mkDerivation rec {
  pname = "neocmakelsp";
  version = "0.8.13";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-MRno86pi389p2lBTu86LCPx5yFN76CbM5AXAs4bsl7c=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-UVXJF8jvZUcEWbsL+UmrO2VSlvowkXNGRbxCEmB89OU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  meta = {
    description = "CMake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      rewine
      multivac61
    ];
    mainProgram = "neocmakelsp";
  };
}

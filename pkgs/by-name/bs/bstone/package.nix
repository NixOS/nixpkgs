{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bstone";
  version = "1.2.13";

  src = fetchFromGitHub {
    owner = "bibendovsky";
    repo = "bstone";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jK40/FdC11SWe2Vmh6cbNTxPeM1vrAveEtUWoiAh+jc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libGL
    SDL2
  ];

  postInstall = ''
    mkdir -p $out/bin
    mv $out/bstone* $out/bin
  '';

  meta = {
    description = "Unofficial source port for the Blake Stone series";
    homepage = "https://github.com/bibendovsky/bstone";
    changelog = "https://github.com/bibendovsky/bstone/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl2Plus # Original game source code
      mit # BStone
    ];
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "bstone";
    platforms = lib.platforms.linux; # TODO: macOS / Darwin support
  };
})

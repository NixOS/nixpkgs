{
  stdenv,
  lib,
  SDL2,
  SDL2_mixer,
  libGLU,
  libconfig,
  meson,
  ninja,
  pkg-config,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "MAR1D";
  version = "unstable-2023-02-02";

  src = fetchFromGitHub {
    hash = "sha256-kZERhwnTpBhjx6MLdf1bYCWMjtTiId/5a69kRt+/6oY=";
    rev = "fa5dc36e1819a15539ced339ad01672e5a498c5c";
    repo = "MAR1D";
    owner = "Radvendii";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    libconfig
    libGLU
  ];

  patches = [
    # Fix the build on Darwin.
    # https://github.com/Radvendii/MAR1D/pull/4
    (fetchpatch {
      url = "https://github.com/Radvendii/MAR1D/commit/baf3269e90eca69f154a43c4c1ef14677a6300fd.patch";
      hash = "sha256-ybdLA2sO8e0J7w4roSdMWn72OkttD3y+cJ3ScuGiHCI=";
    })
  ];

  meta = with lib; {
    description = "First person Super Mario Bros";
    mainProgram = "MAR1D";
    longDescription = ''
      The original Super Mario Bros as you've never seen it. Step into Mario's
      shoes in this first person clone of the classic Mario game. True to the
      original, however, the game still takes place in a two dimensional world.
      You must view the world as mario does, as a one dimensional line.
    '';
    homepage = "https://mar1d.com";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ taeer ];
    platforms = platforms.unix;
  };
}

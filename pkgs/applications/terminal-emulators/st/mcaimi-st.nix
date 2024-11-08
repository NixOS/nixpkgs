{ lib
, stdenv
, fetchFromGitHub
, fontconfig
, libX11
, libXext
, libXft
, ncurses
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "mcaimi-st";
  version = "0.pre+unstable=2021-08-30";

  src = fetchFromGitHub {
    owner = "mcaimi";
    repo = "st";
    rev = "1a8cad03692ee6d32c03a136cdc76bdb169e15d8";
    hash = "sha256-xyVEvD8s1J9Wj9NB4Gg+0ldvde7M8IVpzCOTttC1IY0=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    fontconfig
    libX11
    libXext
    libXft
    ncurses
  ];

  installPhase = ''
    runHook preInstall

    TERMINFO=$out/share/terminfo make install PREFIX=$out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/gnotclub/xst";
    description = "Suckless Terminal fork";
    mainProgram = "st";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}

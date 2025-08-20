{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  harfbuzz,
  libX11,
  libXext,
  libXft,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "lukesmithxyz-st";
  version = "0.pre+unstable=2021-08-10";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = "st";
    rev = "e053bd6036331cc7d14f155614aebc20f5371d3a";
    hash = "sha256-WwjuNxWoeR/ppJxJgqD20kzrn1kIfgDarkTOedX/W4k=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    fontconfig
    harfbuzz
    libX11
    libXext
    libXft
    ncurses
  ];

  patches = [
    # eliminate useless calls to git inside Makefile
    ./0000-makefile-fix-install.diff
  ];

  installPhase = ''
    runHook preInstall

    TERMINFO=$out/share/terminfo make install PREFIX=$out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/LukeSmithxyz/st";
    description = "Luke Smith's fork of st";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}

{ lib
, stdenv
, fetchFromGitHub
, fontconfig
, harfbuzz
, libX11
, libXext
, libXft
, ncurses
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "siduck76-st";
  version = "0.pre+unstable=2021-08-20";

  src = fetchFromGitHub {
    owner = "siduck76";
    repo = "st";
    rev = "c9bda1de1f3f94ba507fa0eacc96d6a4f338637f";
    hash = "sha256-5n+QkSlVhhku7adtl7TuWhDl3zdwFaXc7Ot1RaIN54A=";
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

  installPhase = ''
    runHook preInstall

    TERMINFO=$out/share/terminfo make install PREFIX=$out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/siduck76/st";
    description = "Fork of st with many add-ons";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}

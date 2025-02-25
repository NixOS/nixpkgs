{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  libX11,
  libXext,
  libXft,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "xst";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "gnotclub";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2pXR9U2tTBd0lyeQ3BjnXW+Ne9aUQg/+rnpmYPPG06A=";
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
    description = "Simple terminal fork that can load config from Xresources";
    mainProgram = "xst";
    license = licenses.mit;
    maintainers = [ maintainers.vyp ];
    platforms = platforms.linux;
  };
}

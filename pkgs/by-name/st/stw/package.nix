{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  fontconfig,
  libXft,
  libXrender,
}:

stdenv.mkDerivation rec {
  pname = "stw";
  version = "unstable-2022-02-04";

  src = fetchFromGitHub {
    owner = "sineemore";
    repo = pname;
    rev = "c034e04ac912c157f9faa35cb769ba93d92486a0";
    sha256 = "sha256-YohHF1O0lm6QWJv/wkS4RVJvWaOjcYSZNls6tt4hbqo==";
  };

  buildInputs = [
    libX11
    fontconfig
    libXft
    libXrender
  ];

  makeFlags = [
    "CC:=$(CC)"
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "Simple text widget for X resembling the watch(1) command";
    license = licenses.mit;
    maintainers = with maintainers; [ somasis ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "stw";
  };
}

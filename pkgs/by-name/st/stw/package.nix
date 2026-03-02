{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  fontconfig,
  libxft,
  libxrender,
}:

stdenv.mkDerivation {
  pname = "stw";
  version = "unstable-2022-02-04";

  src = fetchFromGitHub {
    owner = "sineemore";
    repo = "stw";
    rev = "c034e04ac912c157f9faa35cb769ba93d92486a0";
    sha256 = "sha256-YohHF1O0lm6QWJv/wkS4RVJvWaOjcYSZNls6tt4hbqo==";
  };

  buildInputs = [
    libx11
    fontconfig
    libxft
    libxrender
  ];

  makeFlags = [
    "CC:=$(CC)"
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Simple text widget for X resembling the watch(1) command";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ somasis ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "stw";
  };
}

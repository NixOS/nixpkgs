{
  lib,
  stdenv,
  fetchFromGitHub,
  imlib2,
  autoreconfHook,
  autoconf-archive,
  libX11,
  libXext,
  libXfixes,
  libXcomposite,
  libXinerama,
  pkg-config,
  libbsd,
}:

stdenv.mkDerivation rec {
  pname = "scrot";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "scrot";
    rev = version;
    sha256 = "sha256-ExZH+bjpEvdbSYM8OhV+cyn4j+0YrHp5/b+HsHKAHCA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [
    imlib2
    libX11
    libXext
    libXfixes
    libXcomposite
    libXinerama
    libbsd
  ];

  meta = with lib; {
    homepage = "https://github.com/resurrecting-open-source-projects/scrot";
    description = "Command-line screen capture utility";
    mainProgram = "scrot";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.mitAdvertising;
  };
}

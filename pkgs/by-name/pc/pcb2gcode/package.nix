{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  boost,
  glibmm,
  gtkmm2,
  gerbv,
  librsvg,
}:

stdenv.mkDerivation rec {
  pname = "pcb2gcode";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "pcb2gcode";
    repo = "pcb2gcode";
    rev = "v${version}";
    hash = "sha256-c5YabBqZn6ilIkF3lifTsYyLZMsZN21jDj1hNu0PRAc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    boost
    glibmm
    gtkmm2
    gerbv
    librsvg
  ];

  postPatch = ''
    substituteInPlace ./Makefile.am \
    --replace '`git describe --dirty --always --tags`' '${version}'
  '';

  meta = with lib; {
    description = "Command-line tool for isolation, routing and drilling of PCBs";
    longDescription = ''
      pcb2gcode is a command-line software for the isolation, routing and drilling of PCBs.
      It takes Gerber files as input and it outputs gcode files, suitable for the milling of PCBs.
      It also includes an Autoleveller, useful for the automatic dynamic calibration of the milling depth.
    '';
    homepage = "https://github.com/pcb2gcode/pcb2gcode";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kritnich ];
    platforms = platforms.unix;
  };
}

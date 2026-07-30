{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  glibmm,
  gtkmm2,
  gerbv,
  geos,
  librsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcb2gcode";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "pcb2gcode";
    repo = "pcb2gcode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tuVEtynzC9VBBm5tNNkdSr8Rrj3Oy5QOI6jNTmsIXbs=";
  };

  patches = [
    ./boost-1.89.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "PCB2GCODE_COMPILE_WARNING_AS_ERROR" false)
  ];

  preConfigure = lib.optionalString stdenv.isDarwin ''
    export CXXFLAGS="$CXXFLAGS -fpermissive -Wno-error=c++20-extensions -Wno-error=invalid-constexpr"
  '';

  buildInputs = [
    boost
    glibmm
    gtkmm2
    gerbv
    geos
    librsvg
  ];

  meta = {
    description = "Command-line tool for isolation, routing and drilling of PCBs";
    longDescription = ''
      pcb2gcode is a command-line software for the isolation, routing and drilling of PCBs.
      It takes Gerber files as input and it outputs gcode files, suitable for the milling of PCBs.
      It also includes an Autoleveller, useful for the automatic dynamic calibration of the milling depth.
    '';
    homepage = "https://github.com/pcb2gcode/pcb2gcode";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kritnich ];
    platforms = lib.platforms.unix;
  };
})

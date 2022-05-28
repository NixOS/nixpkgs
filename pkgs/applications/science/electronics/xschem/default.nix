{ stdenv
, fetchFromGitHub
, lib
, bison
, cairo
, flex
, libX11
, libXpm
, pkg-config
, tcl
, tk
}:

stdenv.mkDerivation rec {
  pname = "xschem";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "StefanSchippers";
    repo = "xschem";
    rev = version;
    sha256 = "sha256-C57jo8tAbiqQAgf4Xp2lpFGOr6F1knPpFcYxPiqSM4k=";
  };

  nativeBuildInputs = [ bison flex pkg-config ];

  buildInputs = [ cairo libX11 libXpm tcl tk ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Schematic capture and netlisting EDA tool";
    longDescription = ''
      Xschem is a schematic capture program, it allows creation of
      hierarchical representation of circuits with a top down approach.
      By focusing on interfaces, hierarchy and instance properties a
      complex system can be described in terms of simpler building
      blocks. A VHDL or Verilog or Spice netlist can be generated from
      the drawn schematic, allowing the simulation of the circuit.
    '';
    homepage = "https://xschem.sourceforge.io/stefan/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fbeffa ];
    platforms = platforms.all;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  icestorm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arachne-pnr";
  version = "2019.07.29";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo = "arachne-pnr";
    rev = "c40fb2289952f4f120cc10a5a4c82a6fb88442dc";
    hash = "sha256-7OtLOAzxTQ+nxRExyJIUiizhVELCyaFv3MwgkhnL6VE=";
  };

  enableParallelBuilding = true;
  makeFlags = [
    "PREFIX=$(out)"
    "ICEBOX=${icestorm}/share/icebox"
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace 'echo UNKNOWN' 'echo ${lib.substring 0 10 finalAttrs.src.rev}'
  '';

  meta = {
    description = "Place and route tool for FPGAs";
    mainProgram = "arachne-pnr";
    longDescription = ''
      Arachne-pnr implements the place and route step of
      the hardware compilation process for FPGAs. It
      accepts as input a technology-mapped netlist in BLIF
      format, as output by the Yosys [0] synthesis suite
      for example. It currently targets the Lattice
      Semiconductor iCE40 family of FPGAs [1]. Its output
      is a textual bitstream representation for assembly by
      the IceStorm [2] icepack command.
    '';
    homepage = "https://github.com/cseed/arachne-pnr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      shell
      thoughtpolice
    ];
    platforms = lib.platforms.unix;
  };
})

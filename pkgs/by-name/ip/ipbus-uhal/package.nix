{
  lib,
  stdenv,
  bash,
  cacert,
  boost,
  pugixml,
  python3,
  python3Packages,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uhal";
  version = "2.8.16";
  src = fetchFromGitHub {
    owner = "ipbus";
    repo = "ipbus-software";
    hash = "sha256-R+a9VmONyWh3BEYoMjRcXKv+3HaNcKbJDnYH1hXHdPg=";
    rev = "refs/tags/v${finalAttrs.version}";
  };

  patches = [
    ./avoid-bin-bash.patch
  ];

  nativeBuildInputs = [
    cacert
    python3
  ];
  buildInputs = [
    boost
    pugixml
    python3.pkgs.distutils
    python3.pkgs.pybind11
  ];
  configurePhase = ''
    patchShebangs  uhal/config/install.sh
    patchShebangs uhal/tests/setup.sh
    patchShebangs scripts/doxygen/api_uhal.sh
    patchShebangs config/progress.sh
    patchShebangs config/Makefile.macros
  '';

  enableParallelBuilding = true;

  makeFlags = [ "Set=uhal" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/include
    make Set=uhal install prefix=$out/bin includedir=$out/include
  '';

  meta = {
    description = "Software which pairs with ipbus-firmware";
    longDescription = ''
      Software that provide a reliable high-performance
      control link for particle-physics or other electronics,
      by implementing a simple A32/D32 control protocol
      for reading and modifying memory-mapped resources
      within FPGA-based hardware devices.
    '';
    platforms = lib.platforms.linux;
    homepage = "https://ipbus.web.cern.ch/";
    maintainers = [ lib.maintainers.bashsu ];
    mainProgram = "ipbus-uhal";
  };
})

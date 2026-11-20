{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prjxray";
  version = "0.9.2";

  # The openXC7 fork, which nextpnr-xilinx's database comes from.
  src = fetchFromGitHub {
    owner = "openXC7";
    repo = "prjxray";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-KrPYNm8ooh49WGiJOqZD1dYgptUYNRP/jKU9C4gvgiw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    python3Packages.wrapPython
  ];

  cmakeFlags = [ (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5") ];

  pythonPath = with python3Packages; [
    fasm
    intervaltree
    numpy
    pyjson5
    pyyaml
    simplejson
  ];

  # The Python library and the FASM-to-frames and bitstream-to-FASM converters.
  postInstall = ''
    mkdir -p $out/${python3Packages.python.sitePackages}
    cp -r ../prjxray $out/${python3Packages.python.sitePackages}/
    install -Dm755 ../utils/fasm2frames.py $out/bin/fasm2frames
    install -Dm755 ../utils/bit2fasm.py $out/bin/bit2fasm
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    description = "Documentation and tools for the Xilinx 7-series FPGA bitstream format";
    homepage = "https://github.com/openXC7/prjxray";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ gonsolo ];
    platforms = lib.platforms.linux;
    mainProgram = "xc7frames2bit";
  };
})

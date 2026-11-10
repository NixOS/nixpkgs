{
  lib,
  fetchFromGitHub,
  stdenv,
  boost,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prjpeppercorn";
  version = "1.13";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "prjpeppercorn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vlwb/lWVUUdI95GPE887jque7WmNWtBSxSIRcK6k7cU=";
  };

  sourceRoot = "${finalAttrs.src.name}/libgm";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ];

  cmakeFlags = [
    (lib.cmakeBool "STATIC_BUILD" false)
  ];

  doCheck = true;

  strictDeps = true;

  meta = {
    description = "Documentation and tools for Gatemate FPGA parts";
    longDescription = ''
      Project Peppercorn aims to integrate Gatemate FPGA parts into
      the nextpnr workflow.
    '';
    homepage = "https://github.com/YosysHQ/prjpeppercorn";
    license = lib.licenses.isc;
    mainProgram = "gmpack";
    platforms = lib.platforms.all;
  };
})

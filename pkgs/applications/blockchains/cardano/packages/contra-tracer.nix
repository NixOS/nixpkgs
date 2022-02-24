{ mkDerivation, base, fetchgit, lib }:
mkDerivation {
  pname = "contra-tracer";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/iohk-monitoring-framework/";
    sha256 = "0298dpl29gxzs9as9ha6y0w18hqwc00ipa3hzkxv7nlfrjjz8hmz";
    rev = "808724ff8a19a33d0ed06f9ef59fbd900b08553c";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/contra-tracer; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base ];
  description = "A simple interface for logging, tracing or monitoring";
  license = lib.licenses.asl20;
}

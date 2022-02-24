{ mkDerivation, base, contra-tracer, fetchgit, lib, safe-exceptions
, text, time
}:
mkDerivation {
  pname = "tracer-transformers";
  version = "0.1.0.1";
  src = fetchgit {
    url = "https://github.com/input-output-hk/iohk-monitoring-framework/";
    sha256 = "0298dpl29gxzs9as9ha6y0w18hqwc00ipa3hzkxv7nlfrjjz8hmz";
    rev = "808724ff8a19a33d0ed06f9ef59fbd900b08553c";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/tracer-transformers; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base contra-tracer safe-exceptions time
  ];
  executableHaskellDepends = [ base contra-tracer text time ];
  description = "tracer transformers and examples showing their use";
  license = lib.licenses.asl20;
}

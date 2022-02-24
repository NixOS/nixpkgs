{ mkDerivation, aeson, async, base, fetchgit, iohk-monitoring, lib
, safe-exceptions, stm, text, time, unix, unordered-containers
}:
mkDerivation {
  pname = "lobemo-backend-aggregation";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/iohk-monitoring-framework/";
    sha256 = "0298dpl29gxzs9as9ha6y0w18hqwc00ipa3hzkxv7nlfrjjz8hmz";
    rev = "808724ff8a19a33d0ed06f9ef59fbd900b08553c";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/backend-aggregation; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson async base iohk-monitoring safe-exceptions stm text time unix
    unordered-containers
  ];
  homepage = "https://github.com/input-output-hk/iohk-monitoring-framework";
  description = "provides a backend implementation to aggregate traced values";
  license = lib.licenses.asl20;
}

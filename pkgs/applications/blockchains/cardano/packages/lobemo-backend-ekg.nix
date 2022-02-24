{ mkDerivation, aeson, async, base, bytestring, ekg, ekg-core
, fetchgit, iohk-monitoring, lib, safe-exceptions, snap-core
, snap-server, stm, text, time, unordered-containers
}:
mkDerivation {
  pname = "lobemo-backend-ekg";
  version = "0.1.0.1";
  src = fetchgit {
    url = "https://github.com/input-output-hk/iohk-monitoring-framework/";
    sha256 = "0298dpl29gxzs9as9ha6y0w18hqwc00ipa3hzkxv7nlfrjjz8hmz";
    rev = "808724ff8a19a33d0ed06f9ef59fbd900b08553c";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/backend-ekg; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson async base bytestring ekg ekg-core iohk-monitoring
    safe-exceptions snap-core snap-server stm text time
    unordered-containers
  ];
  homepage = "https://github.com/input-output-hk/iohk-monitoring-framework";
  description = "provides a backend implementation to EKG";
  license = lib.licenses.asl20;
}

{ mkDerivation, aeson, async, base, bytestring, fetchgit
, iohk-monitoring, lib, network, safe-exceptions, stm, text, time
, unix-compat
}:
mkDerivation {
  pname = "lobemo-backend-trace-forwarder";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/iohk-monitoring-framework/";
    sha256 = "0298dpl29gxzs9as9ha6y0w18hqwc00ipa3hzkxv7nlfrjjz8hmz";
    rev = "808724ff8a19a33d0ed06f9ef59fbd900b08553c";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/backend-trace-forwarder; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson async base bytestring iohk-monitoring network safe-exceptions
    stm text time unix-compat
  ];
  homepage = "https://github.com/input-output-hk/iohk-monitoring-framework";
  description = "this backend forwards log items to a trace acceptor";
  license = lib.licenses.asl20;
}

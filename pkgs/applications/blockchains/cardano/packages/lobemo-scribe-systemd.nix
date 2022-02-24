{ mkDerivation, aeson, base, bytestring, fetchgit, hsyslog
, iohk-monitoring, katip, lib, libsystemd-journal, template-haskell
, text, unix, unordered-containers
}:
mkDerivation {
  pname = "lobemo-scribe-systemd";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/iohk-monitoring-framework/";
    sha256 = "0298dpl29gxzs9as9ha6y0w18hqwc00ipa3hzkxv7nlfrjjz8hmz";
    rev = "808724ff8a19a33d0ed06f9ef59fbd900b08553c";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/plugins/scribe-systemd; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base bytestring hsyslog iohk-monitoring katip
    libsystemd-journal template-haskell text unix unordered-containers
  ];
  homepage = "https://github.com/input-output-hk/iohk-monitoring-framework";
  description = "provides a backend for logging to systemd/journal";
  license = lib.licenses.asl20;
}

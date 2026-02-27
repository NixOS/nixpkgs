{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "adslib";
  version = "0-unstable-2021-11-07";

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = "ADS";
    rev = "a894d4512a51f3ada026efbf9553e75ba9351e2e";
    sha256 = "SEh4yneTM1dfbWRdWlb5gP/uSeoOeE3g7g/rJWSTba8=";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp adslib.so $out/lib/adslib.so
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Beckhoff protocol to communicate with TwinCAT devices";
    homepage = "https://github.com/stlehmann/ADS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}

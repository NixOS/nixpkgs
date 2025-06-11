{
  lib,
  fetchFromGitHub,
  buildGo124Module,
}:

buildGo124Module rec {
  pname = "redli";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = "redli";
    tag = "v${version}";
    hash = "sha256-/D+kE45PN0rWYvBBm4oxjPWgS8kN/LNf76OTC5rBt1g=";
  };

  vendorHash = "sha256-30a/cZNkXsR0+fv74mfFZnvsylqJDRU72t/cwJur1dU=";

  meta = {
    description = "Humane alternative to the Redis-cli and TLS";
    homepage = "https://github.com/IBM-Cloud/redli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tchekda ];
    mainProgram = "redli";
  };
}

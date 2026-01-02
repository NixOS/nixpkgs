{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "redli";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = "redli";
    tag = "v${version}";
    hash = "sha256-pEEfJWDwMBkx2Ff9pHuvO6N8FvEe93pOI3EO40sNV+8=";
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

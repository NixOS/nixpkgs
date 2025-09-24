{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "dupe-krill";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = "dupe-krill";
    rev = "v${version}";
    hash = "sha256-ze9OQHNtujzn2rY24bmFUkz5AYsjoMrwqm4jyQoF53Y=";
  };

  cargoHash = "sha256-OMXxMWMQIYXe41sxM+KQRMRicH61dIXUe51zdXn8ZYM=";

  meta = with lib; {
    description = "Fast file deduplicator";
    homepage = "https://github.com/kornelski/dupe-krill";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ urbas ];
    mainProgram = "dupe-krill";
  };
}

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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ze9OQHNtujzn2rY24bmFUkz5AYsjoMrwqm4jyQoF53Y=";
  };

  cargoHash = "sha256-9/TSmw0XEnEURgrT6Oy3nqnNkmXUHLr0InlKyg4m9sQ=";

  meta = with lib; {
    description = "Fast file deduplicator";
    homepage = "https://github.com/kornelski/dupe-krill";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ urbas ];
    mainProgram = "dupe-krill";
  };
}

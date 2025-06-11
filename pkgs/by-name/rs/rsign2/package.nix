{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "rsign2";
  version = "0.6.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bJeM1HTzmC8QZ488PpqQ0qqdFg1/rjPWuTtqo1GXyHM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-dCZcxtaqcRHhAmgGigBjN0jDfh1VjoosqTDTkqwlXp0=";

  meta = with lib; {
    description = "Command-line tool to sign files and verify signatures";
    homepage = "https://github.com/jedisct1/rsign2";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rsign";
  };
}

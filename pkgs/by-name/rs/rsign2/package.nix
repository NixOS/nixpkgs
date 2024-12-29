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

  cargoHash = "sha256-xqNFJFNV9mIVxzyQvhv5QwHVcXLuH76VYFAsgp5hW+w=";

  meta = with lib; {
    description = "Command-line tool to sign files and verify signatures";
    homepage = "https://github.com/jedisct1/rsign2";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rsign";
  };
}

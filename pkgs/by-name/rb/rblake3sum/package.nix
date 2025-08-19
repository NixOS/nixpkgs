{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "rblake3sum";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "rustshop";
    repo = "rblake3sum";
    rev = "6a8e2576ccc05214eacb75b75a9d4cfdf272161c";
    hash = "sha256-UFk6SJVA58WXhH1CIuT48MEF19yPUe1HD+ekn4LDj8g=";
  };

  cargoHash = "sha256-cxPNqUVNMkNY9Ov7/ajTAwnBd2j/gKDHVLXPtd1aPVA=";

  meta = with lib; {
    description = "Recursive blake3 digest (hash) of a file-system path";
    homepage = "https://github.com/rustshop/rblake3sum";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ dpc ];
    mainProgram = "rblake3sum";
  };
}

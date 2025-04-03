{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "elfcat";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "ruslashev";
    repo = "elfcat";
    rev = version;
    sha256 = "sha256-lmoOwxRGXcInoFb2YDawLKaebkcUftzpPZ1iTXbl++c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3rqxST7dcp/2+B7DiY92C75P0vQyN2KY3DigBEZ1W1w=";

  meta = with lib; {
    description = "ELF visualizer, generates HTML files from ELF binaries";
    homepage = "https://github.com/ruslashev/elfcat";
    license = licenses.zlib;
    maintainers = with maintainers; [ moni ];
    mainProgram = "elfcat";
  };
}

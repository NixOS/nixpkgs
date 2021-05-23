{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.10.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "17x514pwbkzkkrd47a66a4iz3bxrxvm8hk5hphsfbhgzqfnf9iy7";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "03y2fk174rdjvw8wdzwc0hhj0zqwpap7qcga51yhq877rgyxbxir";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}

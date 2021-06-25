{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.14.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "012wyl6qvwca5r8kqf8j7r50r1lbv802c90m13xb7rqyb6jjfv0m";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "1mgi7hxsn9wajxr78kr3n4g7fa0rwp4riah8dq06cqwjlh0pkfjd";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}

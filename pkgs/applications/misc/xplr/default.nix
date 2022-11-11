{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TH5ksbEVBlOPmqQOtRmoHTDBRkj/KaMsM+Xc7e2ObzY=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "sha256-RcH1J5I9FPQ/Npq4I5lcOsZHzvKyYhxmqOIEYcBXqU0=";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://xplr.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 thehedgeh0g ];
  };
}

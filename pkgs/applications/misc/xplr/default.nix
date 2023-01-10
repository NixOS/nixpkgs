{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b3TdhziXPytHitilMBkr6OGaI+CBI3w4qcTIkQtOAjs=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "sha256-pdXLuogkz5q4+B/y/alA900OHVGBT8W6BR7I2aH8IaA=";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://xplr.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 thehedgeh0g ];
  };
}

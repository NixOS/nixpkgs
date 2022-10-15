{ lib, stdenv, rustPlatform, fetchFromGitHub, perl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.14.6";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tsPCx/4ap2udfZHRK5ebxRYEBYw2W6EgnDI6P3riV04=";
  };

  cargoSha256 = "sha256-xpUI8IflLqBrwsU5YccGzQlPUJT46GJa5AdsIv9qfjU=";

  nativeBuildInputs = [ perl ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}

{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, openssl, pkg-config }:

with rustPlatform;

buildRustPackage rec {
  pname = "cfdyndns";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "colemickens";
    repo = "cfdyndns";
    rev = "93221d18c42b6cdc766fa43c88bf11dbfc585d9d";
    sha256 = "1q6mm586vn2928fb567yi09d0iclw2b51xh2kdzawzi2qpgc2vhs";
  };

  cargoSha256 = "0xa8w792rsyj1pb6i1rxsn2b1wk4bdm0kmbfhq7yzndfngbrapss";

  buildInputs = [ makeWrapper openssl pkg-config];

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/cfdyndns $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "CloudFlare Dynamic DNS Client";
    homepage = https://github.com/colemickens/cfdyndns;
    license = stdenv.lib.licenses.mit;
    maintainers = with maintainers; [ colemickens ];
    platforms = with platforms; linux;
  };
}

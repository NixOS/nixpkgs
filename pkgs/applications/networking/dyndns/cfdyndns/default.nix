{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, openssl }:

with rustPlatform;

buildRustPackage rec {
  name = "cfdyndns-${version}";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "colemickens";
    repo = "cfdyndns";
    rev = "v${version}";
    sha256 = "1mcdjykrgh0jq6k6y664lai8sbgzk6j7k0r944f43vg63d1jql5b";
  };

  depsSha256 = "0whs3fgmpb6g1mjajs3qs9g613x5dal4x6ghzzkpl73a9pgydkpn";

  buildInputs = [ makeWrapper openssl ];

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

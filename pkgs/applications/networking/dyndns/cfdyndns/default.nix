{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl }:

with rustPlatform;

buildRustPackage rec {
  pname = "cfdyndns";
  version = "0.0.3";
  src = fetchFromGitHub {
    owner = "colemickens";
    repo = "cfdyndns";
    rev = "v${version}";
    sha256 = "1fba0w2979dmc2wyggqx4fj52rrl1s2vpjk6mkj1811a848l1hdi";
  };

  cargoSha256 = "14p55gq367yhy858k2kfdijv6r19grcvjswq2gcb6ar3mfqrxmpc";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

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

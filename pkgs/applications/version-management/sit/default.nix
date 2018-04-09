{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "sit-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "sit-it";
    repo = "sit";
    rev = "v${version}";
    sha256 = "1gcw5fqaqpxl2xgry0w8750g2msrk884zj1slym6r3nj7s2m9j22";
  };

  cargoSha256 = "0hb82j97m8vw8m6gpb6s3bbi31xxv9nqh3aq7hkbmp1pqc02sg3q";

  meta = with stdenv.lib; {
    description = "SCM-agnostic, file-based, offline-first, immutable issue tracker";
    homepage = http://sit-it.org/;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}

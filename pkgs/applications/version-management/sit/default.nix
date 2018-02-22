{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "sit-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "sit-it";
    repo = "sit";
    rev = "v${version}";
    sha256 = "0fvxv9x971s5qvhw6gpbw9ggsxynkwfy1fn5rln50gn9yrjf7612";
  };

  cargoSha256 = "1y8a8a9jn9f374sy5fs1snmpiqyckqc0aw7idwnpfr912c1zzrxw";

  meta = with stdenv.lib; {
    description = "SCM-agnostic, file-based, offline-first, immutable issue tracker";
    homepage = http://sit-it.org/;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}

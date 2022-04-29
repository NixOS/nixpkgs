{ lib, stdenv, fetchFromGitHub, rustPlatform, cmake, libzip, gnupg,
  # Darwin
  libiconv, CoreFoundation, Security }:

rustPlatform.buildRustPackage rec {
  pname = "sit";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "sit-fyi";
    repo = "sit";
    rev = "v${version}";
    sha256 = "06xkhlfix0h6di6cnvc4blbj3mjy90scbh89dvywbx16wjlc79pf";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libzip gnupg ]
    ++ (lib.optionals stdenv.isDarwin [ libiconv CoreFoundation Security ]);

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  cargoSha256 = "1ghr01jcq12ddna5qadvjy6zbgqgma5nf0qv06ayxnra37d2l92l";

  meta = with lib; {
    description = "Serverless Information Tracker";
    homepage = "https://sit.fyi/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir yrashk ];
    # Upstream has not had a release in several years, and dependencies no
    # longer compile with the latest Rust compiler.
    broken = true;
  };
}

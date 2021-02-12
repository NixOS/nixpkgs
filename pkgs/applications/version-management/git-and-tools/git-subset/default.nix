{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, curl, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-subset";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jasonwhite";
    repo = pname;
    rev = "v${version}";
    sha256 = "02z2r0kcd0nnn1zjslp6xxam5ddbhrmzn67qzxhlamsw0p9vvkbb";
  };

  cargoSha256 = "173nb1l0pn207vvs732dgg15xln9zcybwcmg8prbnicqkb9i4rjz";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ curl libiconv Security ];

  meta = with lib; {
    description = "Super fast Git tree filtering";
    homepage = "https://github.com/jasonwhite/git-subset";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}

{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, curl, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "11b0adh46fr0j61pz286pycqz15m1b9pfvlz7z08cd0gw526l3f0";
  };

  cargoSha256 = "1s3v5p6qgz74sh34gvajf453fsgl13sds4v8hz8c6ivipz4hpby2";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with stdenv.lib; {
    description = "Cleanup stale Git branches of pull requests";
    homepage = "https://github.com/lunaryorn/git-gone";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
  };
}

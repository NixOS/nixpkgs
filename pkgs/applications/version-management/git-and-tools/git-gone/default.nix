{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, curl, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vgkx227wpg9l2zza6446wzshjhnrhba3qhabibn4gg8wwcqmmxf";
  };

  cargoSha256 = "11h2whlgjhg3j98a9w9k29njj89wx93w0dcyf981985flin709sx";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ curl libiconv Security ];

  meta = with stdenv.lib; {
    description = "Cleanup stale Git branches of pull requests";
    homepage = "https://github.com/lunaryorn/git-gone";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
  };
}

{ stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner  = "tummychow";
    repo   = pname;
    rev    = "refs/tags/${version}";
    sha256 = "0lggv3knh6iglkh8x2zqvqcs3dlwfsdiclg7pmdrycny72la4k2j";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  cargoSha256 = "13gikjswbb0kkpvb5zhj88qq5l667624gkfb7hd3zygh4qyhsy05";

  meta = with stdenv.lib; {
    homepage = "https://github.com/tummychow/git-absorb";
    description = "git commit --fixup, but automatic";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.marsam ];
  };
}

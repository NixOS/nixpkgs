{ stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  name = "git-absorb-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner  = "tummychow";
    repo   = "git-absorb";
    rev    = "refs/tags/${version}";
    sha256 = "1dm442lyk7f44bshm2ajync5pzdwvdc5xfpw2lkvjzxflmh5572z";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  cargoSha256 = "0q40qcki49dw23n3brgdz5plvigmsf61jm0kfy48j89mijih8zy7";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "git commit --fixup, but automatic";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.marsam ];
  };
}

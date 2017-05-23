{ stdenv, fetchFromGitHub, fetchpatch, cmake, python, vim }:

stdenv.mkDerivation rec {
  name = "cryptominisat-${version}";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "msoos";
    repo = "cryptominisat";
    rev = version;
    sha256 = "0cpw5d9vplxvv3aaplhnga55gz1hy29p7s4pkw1306knkbhlzvkb";
  };

  # vim for xxd binary
  buildInputs = [ python vim ];
  nativeBuildInputs = [ cmake ];

  patches = [(fetchpatch rec {
    name = "fix-exported-library-name.patch";
    url = "https://github.com/msoos/cryptominisat/commit/7a47795cbe5ad5a899731102d297f234bcade077.patch";
    sha256 = "11hf3cfqs4cykn7rlgjglq29lzqfxvlm0f20qasi0kdrz01cr30f";
  })];

  meta = with stdenv.lib; {
    description = "An advanced SAT Solver";
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
    license = licenses.mit;
    homepage = https://github.com/msoos/cryptominisat;
  };
}

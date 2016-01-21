{ stdenv, fetchFromGitHub, python }:

stdenv.mkDerivation rec {
  name = "z3-${version}";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner  = "Z3Prover";
    repo   = "z3";
    rev    = "z3-${version}";
    sha256 = "1ix100r1h00iph1bk5qx5963gpqaxmmx42r2vb5zglynchjif07c";
  };

  buildInputs = [ python ];
  enableParallelBuilding = true;

  configurePhase = "python scripts/mk_make.py --prefix=$out && cd build";

  # z3's install phase is stupid because it tries to calculate the
  # python package store location itself, meaning it'll attempt to
  # write files into the nix store, and fail.
  soext = if stdenv.system == "x86_64-darwin" then ".dylib" else ".so";
  installPhase = ''
    mkdir -p $out/bin $out/lib/${python.libPrefix}/site-packages $out/include
    cp ../src/api/z3*.h       $out/include
    cp ../src/api/c++/z3*.h   $out/include
    cp z3                     $out/bin
    cp libz3${soext}          $out/lib
    cp libz3${soext}          $out/lib/${python.libPrefix}/site-packages
    cp z3*.pyc                $out/lib/${python.libPrefix}/site-packages
    cp ../src/api/python/*.py $out/lib/${python.libPrefix}/site-packages
  '';

  meta = {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://github.com/Z3Prover/z3";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}

{ stdenv, fetchFromGitHub, python2 }:

# Copied shamelessly from the normal z3 .nix

let
  python = python2;
in stdenv.mkDerivation rec {
  name = "z3_opt-${version}";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner  = "Z3Prover";
    repo   = "z3";
    rev    = "9377779e5818b2ca15c4f39921b2ba3a42f948e7";
    sha256 = "15d6hsb61hrm5vy3l2gnkrfnqr68lvspnznm17vyhm61ld33yaff";
  };

  buildInputs = [ python ];
  enableParallelBuilding = true;

  configurePhase = "${python.interpreter} scripts/mk_make.py --prefix=$out && cd build";

  # z3's install phase is stupid because it tries to calculate the
  # python package store location itself, meaning it'll attempt to
  # write files into the nix store, and fail.
  soext = if stdenv.system == "x86_64-darwin" then ".dylib" else ".so";
  installPhase = ''
    mkdir -p $out/bin $out/${python.sitePackages} $out/include
    cp ../src/api/z3*.h       $out/include
    cp ../src/api/c++/z3*.h   $out/include
    cp z3                     $out/bin
    cp libz3${soext}          $out/lib
    cp libz3${soext}          $out/${python.sitePackages}
    cp z3*.pyc                $out/${python.sitePackages}
    cp ../src/api/python/*.py $out/${python.sitePackages}
  '';

  meta = {
    description = "A high-performance theorem prover and SMT solver, optimization edition";
    homepage    = "https://github.com/Z3Prover/z3";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice sheganinans ];
  };
}


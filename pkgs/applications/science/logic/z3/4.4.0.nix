{ lib, stdenv, fetchFromGitHub, python }:

stdenv.mkDerivation rec {
  pname = "z3";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner  = "Z3Prover";
    repo   = "z3";
    rev    = "7f6ef0b6c0813f2e9e8f993d45722c0e5b99e152";
    sha256 = "1xllvq9fcj4cz34biq2a9dn2sj33bdgrzyzkj26hqw70wkzv1kzx";
  };

  buildInputs = [ python ];
  enableParallelBuilding = true;

  CXXFLAGS = if stdenv.isDarwin then "-std=gnu++98" else null;

  configurePhase = "python scripts/mk_make.py --prefix=$out && cd build";

  # z3's install phase is stupid because it tries to calculate the
  # python package store location itself, meaning it'll attempt to
  # write files into the nix store, and fail.
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
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
    homepage    = "https://github.com/Z3Prover/z3";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.x86_64;
    maintainers = with lib.maintainers; [ thoughtpolice ttuegel ];
  };
}

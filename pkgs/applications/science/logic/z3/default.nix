{ stdenv, fetchFromGitHub, python, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "z3";
  version = "4.8.5";

  src = fetchFromGitHub {
    owner  = "Z3Prover";
    repo   = pname;
    rev    = "Z3-${version}";
    sha256 = "11sy98clv7ln0a5vqxzvh6wwqbswsjbik2084hav5kfws4xvklfa";
  };

  buildInputs = [ python fixDarwinDylibNames ];
  propagatedBuildInputs = [ python.pkgs.setuptools ];
  enableParallelBuilding = true;

  configurePhase = ''
    ${python.interpreter} scripts/mk_make.py --prefix=$out --python --pypkgdir=$out/${python.sitePackages}
    cd build
  '';

  postInstall = ''
    mkdir -p $dev $lib $python/lib

    mv $out/lib/python*  $python/lib/
    mv $out/lib          $lib/lib
    mv $out/include      $dev/include

    ln -sf $lib/lib/libz3${stdenv.hostPlatform.extensions.sharedLibrary} $python/${python.sitePackages}/z3/lib/libz3${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  outputs = [ "out" "lib" "dev" "python" ];

  meta = {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "https://github.com/Z3Prover/z3";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.x86_64;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}

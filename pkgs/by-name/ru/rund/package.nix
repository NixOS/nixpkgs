{stdenv, lib, fetchFromGitHub, ldc ? null, dcompiler ? ldc }:

assert dcompiler != null;

stdenv.mkDerivation rec {
  pname = "rund";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dragon-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "10x6f1nn294r5qnpacrpcbp348dndz5fv4nz6ih55c61ckpkvgcf";
  };

  buildInputs = [ dcompiler ];
  buildPhase = ''
    for candidate in dmd ldmd2 gdmd; do
      echo Checking for DCompiler $candidate ...
      dc=$(type -P $candidate || echo "")
      if [ ! "$dc" == "" ]; then
        break
      fi
    done
    if [ "$dc" == "" ]; then
      exit "Error: could not find a D compiler"
    fi
    echo Using DCompiler $candidate
    $dc -I=$src/src -i -run $src/make.d build --out $NIX_BUILD_TOP
  '';

  doCheck = true;
  checkPhase = ''
    $NIX_BUILD_TOP/rund make.d test
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv $NIX_BUILD_TOP/rund $out/bin
  '';

  meta = with lib; {
    description = "Compiler-wrapper that runs and caches D programs";
    mainProgram = "rund";
    homepage = "https://github.com/dragon-lang/rund";
    license = lib.licenses.boost;
    maintainers = with maintainers; [ jonathanmarler ];
    platforms = lib.platforms.unix;
  };
}

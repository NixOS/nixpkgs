{
  stdenv,
  lib,
  fetchFromGitHub,
  ldc ? null,
  dcompiler ? ldc,
}:

assert dcompiler != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "rund";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dragon-lang";
    repo = "rund";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jr0972TBsFJgNN+S7cpvtiEy7mI3M3UtLpkkYW1wpoM=";
  };

  buildInputs = [ dcompiler ];
  buildPhase = ''
    for candidate in dmd ldmd2; do
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

  meta = {
    description = "Compiler-wrapper that runs and caches D programs";
    mainProgram = "rund";
    homepage = "https://github.com/dragon-lang/rund";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ jonathanmarler ];
    platforms = lib.platforms.unix;
  };
})

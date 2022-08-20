{ stdenv
, fetchFromGitHub
, lib
, python3
, cmake
, lingeling
, btor2tools
, gtest
, gmp
, cadical
, minisat
, picosat
, cryptominisat
, zlib
, pkg-config
  # "*** internal error in 'lglib.c': watcher stack overflow" on aarch64-linux
, withLingeling ? !stdenv.hostPlatform.isAarch64
}:

stdenv.mkDerivation rec {
  pname = "bitwuzla";
  version = "unstable-2022-08-07";

  src = fetchFromGitHub {
    owner = "bitwuzla";
    repo = "bitwuzla";
    rev = "b6fb61736a5cf70cd0b35ec4aeeadf23971610ce";
    hash = "sha256-T5VnnWrcZ8K1NjFf5eeg0TRpXBLRCxC67v8zWPwYF/Y=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    cadical
    cryptominisat
    picosat
    minisat
    btor2tools
    gmp
    zlib
  ] ++ lib.optional withLingeling lingeling;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DPicoSAT_INCLUDE_DIR=${lib.getDev picosat}/include/picosat"
    "-DBtor2Tools_INCLUDE_DIR=${lib.getDev btor2tools}/include/btor2parser"
    "-DBtor2Tools_LIBRARIES=${lib.getLib btor2tools}/lib/libbtor2parser${stdenv.hostPlatform.extensions.sharedLibrary}"
  ] ++ lib.optional doCheck "-DTESTING=YES";

  checkInputs = [ python3 gtest ];
  # two tests fail on darwin and 3 on aarch64-linux
  doCheck = stdenv.hostPlatform.isLinux && (!stdenv.hostPlatform.isAarch64);
  preCheck = let
    var = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
  in
    ''
      export ${var}=$(readlink -f lib)
      patchShebangs ..
    '';

  meta = with lib; {
    description = "A SMT solver for fixed-size bit-vectors, floating-point arithmetic, arrays, and uninterpreted functions";
    homepage = "https://bitwuzla.github.io";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ symphorien ];
  };
}

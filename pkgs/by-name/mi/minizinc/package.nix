{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  jq,
  cmake,
  flex,
  bison,
  gecode,
  mpfr,
  cbc,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minizinc";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
    tag = finalAttrs.version;
    hash = "sha256-pQsH0ofXPW52CnhH2qO9XmFGO8rGxojCNxRNIGiemmU=";
  };

  nativeBuildInputs = [
    bison
    cmake
    flex
    jq
  ];

  buildInputs = [
    gecode
    mpfr
    cbc
    zlib
  ];

  postInstall = ''
    mkdir -p $out/share/minizinc/solvers/
    jq \
      '.version = "${gecode.version}"
       | .mznlib = "${gecode}/share/minizinc/gecode/"
       | .executable = "${gecode}/bin/fzn-gecode"' \
       ${./gecode.msc} \
       >$out/share/minizinc/solvers/gecode.msc
  '';

  passthru.tests = {
    simple = callPackage ./simple-test { };
  };

  meta = {
    homepage = "https://www.minizinc.org/";
    description = "Medium-level constraint modelling language";
    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  callPackage,
  jq,
  cmake,
  flex,
  bison,
  gecode,
  cbc,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minizinc";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
    tag = finalAttrs.version;
    hash = "sha256-FYXofYaAGYMIlzwQV2rP+1Sv8OYbaqH4jHzB4J4c8G4=";
  };

  patches = [
    # Compatibility with Gecode 6.5.0
    (fetchpatch {
      url = "https://github.com/MiniZinc/libminizinc/commit/4a84a48ac8fb31010a421a038a0cfbcac501ee1f.patch";
      includes = [
        "CMakeLists.txt"
        "cmake/*"
      ];
      hash = "sha256-W4wkylQalL8j0eTVDimMr6hzth8zfzFzPrWvLZ4+PBo=";
    })
  ];

  nativeBuildInputs = [
    bison
    cmake
    flex
    jq
  ];

  buildInputs = [
    gecode
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

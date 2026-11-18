{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  callPackage,
  jq,
  cmake,
  flex,
  bison,
  gecode,
  cbc,
  zlib,
}:

let
  # The URLs and hashes below are taken from the cmake configuration files
  fetch =
    { url, hash }@arg:
    {
      inherit url;
      file = fetchurl arg;
    };
  mimalloc = fetch {
    url = "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.5.3.tar.gz";
    hash = "sha256:3b4a15153a59905995f7070296ed604bb5ccc00cabb8b93446931aff77224d47";
  };
  tree-sitter = fetch {
    url = "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.12.tar.gz";
    hash = "sha256:428e2b182fe38eddc100d8bd851e47c96921a69281b66abafc25ba4b0aaeeeab";
  };
  tree_feller = fetch {
    url = "https://github.com/Dekker1/tree-feller/archive/refs/tags/v0.1.1.tar.gz";
    hash = "sha256:4a6b463da95ec6a9a1014732df6e77dabdb5e20c95cd9005107d1d4596e92cf9";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "minizinc";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
    tag = finalAttrs.version;
    hash = "sha256-uCm/LVxBGIguURt67uomH4LBr6mcttDMqZABLvpZH+U=";
  };

  preConfigure = ''
    substituteInPlace cmake/targets/libminizinc_parser.cmake \
    --replace-fail ${tree-sitter.url} "${tree-sitter.file}" \
    --replace-fail ${tree_feller.url} "${tree_feller.file}"
    substituteInPlace cmake/targets/libmzn.cmake \
    --replace-fail ${mimalloc.url} "${mimalloc.file}"
  '';

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

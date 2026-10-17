{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libyaml,
  icu,
}:

let
  cli11 = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    rev = "291c58789c031208f08f4f261a858b5b7083e8e2";
    hash = "sha256-x3/kBlf5LdzkTO4NYOKanZBfcU4oK+fJw9L7cf88LsY=";
  };
  glob = fetchFromGitHub {
    owner = "p-ranav";
    repo = "glob";
    rev = "8cd16218ae648addf166977d7e41b914768bcb05";
    hash = "sha256-Zkgjon61Z/mmVa+TGmChfv6cvZNsCrRpqr2IDFztSFw=";
  };
  tree_sitter = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    rev = "bdfe32402e85673bbc693216f0a6ef72c98bb665";
    hash = "sha256-2Pg4D1Pf1Ex6ykXouAJvD1NVfg5CH4rCQcSTAJmYwd4=";
  };
  tree_sitter_cpp = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-cpp";
    rev = "30d2fa385735378388a55917e2910965fce19748";
    hash = "sha256-O7EVmGvkMCLTzoxNc+Qod6eCTWs6y8DYVpQqw+ziqGo=";
  };
  tree_sitter_cuda = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-cuda";
    rev = "cbce8aedc6fa35313a4cecd206196011a08a85c4";
    hash = "sha256-Ini+K3Ez6fXhcwbPHb0T8tbKzIASz86YF8ciSt39Aos=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "doxide";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lawmurray";
    repo = "doxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s/kRMbS2j/CXuv6zJlOE+KMJDpem001PsuRtf/DuCkM=";
  };

  postUnpack = ''
    mkdir -p contrib
    rm -rf contrib/glob
    ln -s ${glob} contrib/glob
    rm -rf contrib/CLI11
    ln -s ${cli11} contrib/CLI11
    rm -rf contrib/tree-sitter
    ln -s ${tree_sitter} contrib/tree-sitter
    rm -rf contrib/tree-sitter-cpp
    ln -s ${tree_sitter_cpp} contrib/tree-sitter-cpp
    rm -rf contrib/tree-sitter-cuda
    ln -s ${tree_sitter_cuda} contrib/tree-sitter-cuda
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    icu
    libyaml
  ];

  doCheck = true;

  meta = {
    description = "Modern documentation for modern C++";
    longDescription = ''
      Doxide is a documentation generator for C++. By generating Markdown,
      Doxide opens C++ documentation to the whole wide world of static site
      generation tools and themes.
    '';
    homepage = "https://doxide.org";
    changelog = "https://github.com/lawmurray/doxide/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ryex ];
    mainProgram = "doxide";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

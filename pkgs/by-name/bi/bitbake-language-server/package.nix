{ lib
, nix-update-script
, python3
, fetchFromGitHub
, cmake
, ninja
}:
let
  tree-sitter-bitbake = fetchFromGitHub {
    owner = "amaanq";
    repo = "tree-sitter-bitbake";
    rev = "v1.0.0";
    hash = "sha256-HfWUDYiBCmtlu5fFX287BSDHyCiD7gqIVFDTxH5APAE=";
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "bitbake-language-server";
  version = "0.0.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Freed-Wu";
    repo = pname;
    rev = version;
    hash = "sha256-UOeOvaQplDn7jM+3sUZip1f05TbczoaRQKMxVm+euDU=";
  };

  nativeBuildInputs = with python3.pkgs; [
    cmake
    ninja
    pathspec
    pyproject-metadata
    scikit-build-core
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    lsprotocol
    platformdirs
    pygls
    tree-sitter
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  # The scikit-build-core runs CMake internally so we must let it run the configure step itself.
  dontUseCmakeConfigure = true;
  SKBUILD_CMAKE_ARGS = lib.strings.concatStringsSep ";" [
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DFETCHCONTENT_QUIET=OFF"
    "-DFETCHCONTENT_SOURCE_DIR_TREE-SITTER-BITBAKE=${tree-sitter-bitbake}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Language server for bitbake";
    homepage = "https://github.com/Freed-Wu/bitbake-language-server";
    changelog = "https://github.com/Freed-Wu/bitbake-language-server/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ otavio ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  tree-sitter,
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "tree-sitter-languages";
  version = "1.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grantjenks";
    repo = "py-tree-sitter-languages";
    rev = "v${version}";
    hash = "sha256-wKU2c8QRBKFVFqg+DAeH5+cwm5jpDLmPZG3YBUsh/lM=";
    # Use git, to also fetch tree-sitter repositories that upstream puts their
    # hases in the repository as well, in repos.txt.
    forceFetchGit = true;
    postFetch = ''
      cd $out
      substitute build.py get-repos.py \
        --replace-fail "from tree_sitter import Language" "" \
        --replace-fail 'print(f"{sys.argv[0]}: Building", languages_filename)' "exit(0)"
      ${python.pythonOnBuildForHost.interpreter} get-repos.py
      rm -rf vendor/*/.git
    '';
  };

  build-system = [
    setuptools
    cython
  ];
  dependencies = [ tree-sitter ];
  # Generate languages.so file (build won't fail without this, but tests will).
  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} build.py
  '';
  nativeCheckInputs = [ pytestCheckHook ];
  # Without cd $out, tests fail to import the compiled cython extensions.
  # Without copying the ./tests/ directory to $out, pytest won't detect the
  # tests and run them. See also:
  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cp -r tests $out/${python.sitePackages}/tree_sitter_languages
    cd $out
  '';

  pythonImportsCheck = [ "tree_sitter_languages" ];

  meta = with lib; {
    description = "Binary Python wheels for all tree sitter languages";
    homepage = "https://github.com/grantjenks/py-tree-sitter-languages";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
    # https://github.com/grantjenks/py-tree-sitter-languages/issues/67
    broken = versionAtLeast tree-sitter.version "0.22";
  };
}

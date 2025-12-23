{
  bc,
  zip,
  lib,
  fetchFromGitHub,
  bats,
  buildPythonApplication,
  pythonOlder,
  callPackage,
  kicad,
  numpy,
  click,
  markdown2,
  openscad,
  pytestCheckHook,
  commentjson,
  wxpython,
  pcbnewtransition,
  pybars3,
  versioneer,
  shapely,
  setuptools,
  nix-update-script,
}:
let
  solidpython = callPackage ./solidpython { };
in
buildPythonApplication rec {
  pname = "kikit";
  version = "1.7.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "yaqwsx";
    repo = "KiKit";
    tag = "v${version}";
    hash = "sha256-HSAQJJqJMVh44wgOQm+0gteShLogklBFuIzWtoVTf9I=";
    # Upstream uses versioneer, which relies on gitattributes substitution.
    # This leads to non-reproducible archives on GitHub.
    # See https://github.com/NixOS/nixpkgs/issues/84312
    postFetch = ''
      rm "$out/kikit/_version.py"
    '';
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    kicad
    numpy
    click
    markdown2
    # OpenSCAD is an optional dependency (see
    # https://github.com/yaqwsx/KiKit/blob/v1.5.0/docs/installation/intro.md#optional-dependencies).
    openscad
    commentjson
    # https://github.com/yaqwsx/KiKit/issues/575
    wxpython
    pcbnewtransition
    pybars3
    shapely
    # https://github.com/yaqwsx/KiKit/issues/576
    solidpython
  ];

  nativeBuildInputs = [
    versioneer
    bc
    zip
  ];

  nativeCheckInputs = [
    pytestCheckHook
    bats
  ];

  pythonImportsCheck = [
    "kikit"
  ];

  postPatch = ''
    # Recreate _version.py, deleted at fetch time due to non-reproducibility.
    echo 'def get_versions(): return {"version": "${version}"}' > kikit/_version.py
  '';

  preCheck = ''
    export PATH=$PATH:$out/bin

    make test-system

    # pytest needs to run in a subdir. See https://github.com/yaqwsx/KiKit/blob/v1.3.0/Makefile#L43
    cd test/units
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automation for KiCAD boards";
    homepage = "https://github.com/yaqwsx/KiKit/";
    changelog = "https://github.com/yaqwsx/KiKit/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [
      jfly
      matusf
    ];
    teams = with lib.teams; [ ngi ];
    license = lib.licenses.mit;
  };
}

{
  bc,
  zip,
  lib,
  bats,
  fetchFromGitHub,
  python,
  buildPythonApplication,
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
  versionCheckHook,
  nix-update-script,
}:
let
  solidpython = callPackage ./solidpython { };
in
buildPythonApplication (finalAttrs: {
  pname = "kikit";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yaqwsx";
    repo = "KiKit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QhtdQgMgHaB0xj2hQ4MCptr5DDgCOfRClUSyYzrFQis=";
    # Upstream uses versioneer, which relies on gitattributes substitution.
    # This leads to non-reproducible archives on GitHub.
    # See
    # https://github.com/NixOS/nixpkgs/issues/84312
    # https://github.com/NixOS/nixpkgs/pull/395213
    # https://github.com/python-versioneer/python-versioneer/issues/217
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
    versionCheckHook
    bats
  ];

  pythonImportsCheck = [
    "kikit"
  ];

  # Recreate _version.py, deleted at fetch time due to non-reproducibility.
  # should be done in postInstall to overwrite what versioneer generates again during the build phase
  postInstall = ''
    echo 'def get_versions(): return {"version": "${finalAttrs.version}"}' > $out/${python.sitePackages}/kikit/_version.py
  '';

  preCheck = ''
    export PATH=$PATH:$out/bin

    make test-system

    # pytest needs to run in a subdir. See https://github.com/yaqwsx/KiKit/blob/v1.3.0/Makefile#L43
    cd test/units
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/yaqwsx/KiKit/releases/tag/${finalAttrs.src.tag}";
    description = "Automation for KiCAD boards";
    homepage = "https://github.com/yaqwsx/KiKit/";
    license = lib.licenses.mit;
    mainProgram = "kikit";
    maintainers = with lib.maintainers; [
      jfly
      matusf
    ];
    teams = with lib.teams; [ ngi ];
  };
})

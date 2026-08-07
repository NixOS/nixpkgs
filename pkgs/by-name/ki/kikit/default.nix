{
  bc,
  zip,
  lib,
  bats,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    # Remove when new release is tagged
    # NOTE: not bumping the above with a `rev = latest git commit`
    # because versioneer doesn't handle non-semver versions
    # packaging.version.InvalidVersion: Invalid version: '1.8.0-unstable-2026-07-23'
    # https://github.com/yaqwsx/KiKit/issues/925
    # NOTE: .patch doesn't apply so using diff
    (fetchpatch2 {
      name = "fix-zone-duplication-on-kicad-10.0.5-and-numpy2-stencil-arc.diff";
      url = "https://github.com/yaqwsx/KiKit/compare/6eb4e7aed72165c0179af485a1a1de2d98abfe95..054ac1a5be281e8d74052d3195ad5fb0a701a2ec.diff";
      hash = "sha256-uN6FjhqCLgfZnyGLGg7j1FxHo/nUWYQ6rYVx7kUXh7g=";
    })
  ];

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
  # Must include version_json block because versioneer uses regex parsing on this file.
  postPatch = ''
    cat > kikit/_version.py <<'EOF'
    # DO NOT EDIT! nixpkgs GENERATED FILE
    import json

    version_json = ''''
    {
     "version": "${finalAttrs.version}"
    }
    ''''  # END VERSION_JSON

    def get_versions():
        return json.loads(version_json)
    EOF
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

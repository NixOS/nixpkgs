{
  lib,
  python3Packages,
  fetchFromGitHub,
  basedpyright,
  # codebook,
  ruff,
  ty,
}:

let
  version = "0.3.3";
in
python3Packages.buildPythonApplication {
  pname = "rassumfrassum";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joaotavora";
    repo = "rassumfrassum";
    tag = "v${version}";
    hash = "sha256-3Hcews5f7o45GUmFdpLwkAHf0bthC1tUikkxau952Ec=";
  };

  postPatch = ''
    patchShebangs rass test/
  '';

  build-system = [ python3Packages.setuptools ];

  # The test suite is timing-sensitive at present and running it on
  # Hydra does not add much value in any case, given that this package
  # depends on nothing but core Python, and that nothing depends on
  # this package...
  doCheck = false;

  # ...but let's have the plumbing in place for if/when it becomes
  # possible to run tests on Hydra reliably.
  nativeCheckInputs = [
    # codebook (does not work in sandbox)
    basedpyright
    ruff
    ty
  ];

  checkPhase = ''
    test/run-all.sh
  '';

  meta = {
    description = "Connect an LSP client to multiple LSP servers";
    homepage = "https://github.com/joaotavora/rassumfrassum";
    changelog = "https://github.com/joaotavora/rassumfrassum/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.cmm ];
  };
}

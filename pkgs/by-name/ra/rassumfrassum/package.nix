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
  version = "0.2.1";
in
python3Packages.buildPythonApplication {
  pname = "rassumfrassum";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joaotavora";
    repo = "rassumfrassum";
    tag = "v${version}";
    hash = "sha256-fZr1GqvsGmvCnm2CnOiLj7Yyqs1HL4nxbQMDNWxKPT0=";
  };

  postPatch = ''
    patchShebangs rass test/
  '';

  build-system = [ python3Packages.setuptools ];

  nativeCheckInputs = [
    # codebook (crashes on exit in tests, for whatever reason)
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

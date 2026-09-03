{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "aqtinstall";
  version = "3.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "miurahr";
    repo = "aqtinstall";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CXG8GH1MSS2HhDA/SnqQP7mQG+/OfZ5P6JRG8ZIVlLs=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"bs4"' '"beautifulsoup4"'
  '';

  dependencies = with python3Packages; [
    beautifulsoup4
    defusedxml
    humanize
    patch-ng
    py7zr
    requests
    semantic-version
    texttable
  ];

  # Tests require network access
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial Qt installer";
    homepage = "https://github.com/miurahr/aqtinstall";
    changelog = "https://github.com/miurahr/aqtinstall/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BatteredBunny ];
    mainProgram = "aqt";
  };
})

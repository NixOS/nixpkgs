{
  lib,
  python3Packages,
  fetchFromGitHub,
  nixosTests,
  fetchNpmDeps,
  nodejs,
  npmHooks,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "isso";
  version = "0.14.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "isso-comments";
    repo = "isso";
    tag = finalAttrs.version;
    hash = "sha256-8kXqqiMXxF0wCJ+AzYT8j0rjuhlXO3F6UJbump672b4=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-e3r5iZLmXlf5YBPGgeNBDkdgfbNcIZIXbRLyyoyJiTU=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    # Remove test for (misaka) outdated alternative to mistune
    # so we can drop misaka from nixpkgs.
    rm isso/tests/test_html_misaka.py
  '';

  propagatedBuildInputs = with python3Packages; [
    itsdangerous
    jinja2
    mistune
    html5lib
    werkzeug
    bleach
    flask-caching
  ];

  nativeBuildInputs = [
    python3Packages.cffi
    python3Packages.sphinxHook
    python3Packages.sphinx
    nodejs
    npmHooks.npmConfigHook
  ];

  env.NODE_PATH = "$npmDeps";

  preBuild = ''
    ln -s ${finalAttrs.npmDeps}/node_modules ./node_modules
    export PATH="${finalAttrs.npmDeps}/bin:$PATH"

    make js
  '';

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    python3Packages.pytest-cov-stub
  ];

  passthru.tests = { inherit (nixosTests) isso; };

  meta = {
    description = "Commenting server similar to Disqus";
    mainProgram = "isso";
    homepage = "https://isso-comments.de";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})

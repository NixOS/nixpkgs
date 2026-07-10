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
    owner = "posativ";
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
    # Remove when https://github.com/posativ/isso/pull/973 is available.
    substituteInPlace isso/tests/test_comments.py \
      --replace "self.client.delete_cookie('localhost.local', '1')" "self.client.delete_cookie(key='1', domain='localhost')"
  '';

  propagatedBuildInputs = with python3Packages; [
    itsdangerous
    jinja2
    misaka
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
    homepage = "https://posativ.org/isso/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})

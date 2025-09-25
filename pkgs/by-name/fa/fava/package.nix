{
  lib,
  python3Packages,
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
}:
let
  src = buildNpmPackage (finalAttrs: {
    pname = "fava-frontend";
    version = "1.30.6";

    src = fetchFromGitHub {
      owner = "beancount";
      repo = "fava";
      tag = "v${finalAttrs.version}";
      hash = "sha256-AMbKGIfR/URu7RpyBKSR3lzfIliRWjnUNNjLvu9KmfM=";
    };
    sourceRoot = "${finalAttrs.src.name}/frontend";

    npmDepsHash = "sha256-geou0+Ges0jjrlXG9m3u1GMdf0Qt2pTd8vRGh9gAWJ4=";
    makeCacheWritable = true;

    preBuild = ''
      chmod -R u+w ..
    '';

    installPhase = ''
      runHook preInstall
      cp -R .. $out
      runHook postInstall
    '';
  });
in
python3Packages.buildPythonApplication {
  pname = "fava";
  version = "1.30.6";
  pyproject = true;

  inherit src;

  patches = [ ./dont-compile-frontend.patch ];

  postPatch = ''
    substituteInPlace tests/test_cli.py \
      --replace-fail '"fava"' '"${placeholder "out"}/bin/fava"'
  '';

  build-system = [ python3Packages.setuptools-scm ];

  dependencies = with python3Packages; [
    babel
    beancount
    beangulp
    beanquery
    cheroot
    click
    flask
    flask-babel
    jinja2
    markdown2
    ply
    simplejson
    werkzeug
    watchfiles
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  # tests/test_cli.py
  __darwinAllowLocalNetworking = true;

  # flaky, fails only on ci
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_core_watcher.py" ];

  env = {
    # Disable some tests when building with beancount2
    SNAPSHOT_IGNORE = lib.versions.major python3Packages.beancount.version == "2";
  };

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  meta = {
    description = "Web interface for beancount";
    mainProgram = "fava";
    homepage = "https://beancount.github.io/fava";
    changelog = "https://beancount.github.io/fava/changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bhipple
      prince213
      sigmanificient
    ];
  };
}

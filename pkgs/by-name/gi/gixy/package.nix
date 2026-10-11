{
  lib,
  fetchFromGitHub,
  python3Packages,
  nginx,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gixy";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MegaManSec";
    repo = "Gixy-Next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lMpni9jGKf65Oyi+BxXU/9RzfsGNgQjTpyE/EEPlHow=";
  };

  postPatch = ''
    substituteInPlace tests/cli/test_main.py tests/plugins/test_origins_determinism.py \
      --replace-fail 'sys.executable, "-m", "gixy.cli.main"' '"gixy"'
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    crossplane
    cached-property
    configargparse
    jinja2
    tldextract
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  passthru = {
    inherit (nginx.passthru) tests;
  };

  meta = {
    changelog = "https://github.com/MegaManSec/Gixy-Next/releases/tag/${finalAttrs.src.tag}";
    description = "NGINX Configuration Security Scanner & Performance Checker";
    longDescription = ''
      Gixy-Next (Gixy) is an open-source NGINX configuration security scanner
      and hardening tool that statically analyzes your nginx.conf to detect
      security misconfigurations, hardening gaps, and common performance
      pitfalls before they reach production.
    '';
    homepage = "https://github.com/MegaManSec/Gixy-Next";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mpl20;
    maintainers = [ ];
    mainProgram = "gixy";
    platforms = lib.platforms.unix;
  };
})

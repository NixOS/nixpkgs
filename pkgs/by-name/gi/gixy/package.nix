{
  lib,
  fetchFromGitHub,
  python3Packages,
  nginx,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gixy";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MegaManSec";
    repo = "Gixy-Next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L8Tna+TT8+9lJE/wX5miniA/SchcBnKImp1SBPzbidI=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    crossplane
    cached-property
    configargparse
    jinja2
    tldextract
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

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

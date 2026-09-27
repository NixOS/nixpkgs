{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "quota-tracker";
  version = "0.1.35";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Thomas97460";
    repo = "quota-tracker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OMd9IPp68RpNixzgs51RHGYdryzp+cmrnavdkkHNOpc=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    fastapi
    httpx
    uvicorn
    pydantic
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-cov
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postPatch = ''
    rm -rf quota_tracker/frontend_dist
    mkdir -p quota_tracker/frontend_dist
    cp -r ${finalAttrs.passthru.frontend}/dist/* quota_tracker/frontend_dist/
  '';

  pythonImportsCheck = [ "quota_tracker" ];

  passthru.frontend = buildNpmPackage {
    pname = "${finalAttrs.pname}-frontend";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/frontend";
    npmDepsHash = "sha256-CzfezurcDIJJxCDNb/+5+2r+tutqZ1pIEBSNRw1c/Qg=";
    npmBuildScript = "build";

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist $out/dist
      runHook postInstall
    '';
  };

  meta = {
    description = "Track token usage and quotas for Claude, Copilot, Codex, and Gemini";
    homepage = "https://github.com/Thomas97460/quota-tracker";
    license = lib.licenses.mit;
    mainProgram = "quota-tracker";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Thomas97460 ];
  };
})

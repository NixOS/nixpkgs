{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "jshint";
  version = "2.13.6";

  src = fetchFromGitHub {
    owner = "jshint";
    repo = "jshint";
    tag = finalAttrs.version;
    hash = "sha256-RANA+kL7gL5bGa5KywEH/G+mAsPEoNkfxlp/pHeW8iE=";
  };

  npmDepsHash = "sha256-4P1rQmNIENbJPFqpbgnrq4V2tZe4MWySIphwUtnNcuc=";

  env.PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "1";

  postBuild = ''
    npm run test-node
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool that helps to detect errors and potential problems in your JavaScript code";
    homepage = "https://jshint.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "jshint";
  };
})

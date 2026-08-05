{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  patch2pr,
}:

buildGoModule (finalAttrs: {
  pname = "patch2pr";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "bluekeyes";
    repo = "patch2pr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SMMqLW9Gvrc+lt/AhGD+RRE+dC/6CxSKmUtJJ3SXtLo=";
  };

  vendorHash = "sha256-XVEqnYzlm9l2e/grLwopEZlPSTY64po7veL8JqL9S7Y=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  passthru.tests.patch2pr-version = testers.testVersion {
    package = patch2pr;
    command = "${patch2pr.meta.mainProgram} --version";
    version = finalAttrs.version;
  };

  meta = {
    description = "Create pull requests from patches without cloning the repository";
    homepage = "https://github.com/bluekeyes/patch2pr";
    changelog = "https://github.com/bluekeyes/patch2pr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ katrinafyi ];
    mainProgram = "patch2pr";
  };
})

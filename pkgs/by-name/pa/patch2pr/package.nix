{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  patch2pr,
}:

buildGoModule (finalAttrs: {
  pname = "patch2pr";
  version = "0.48.0";

  src = fetchFromGitHub {
    owner = "bluekeyes";
    repo = "patch2pr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qncP6Ug/5dNKw6B/yGrS/zRCaKOnw38Rld/s9giu7gQ=";
  };

  vendorHash = "sha256-sSjvqW+4KoHP9jSTJxYk0DeJ0VQNQIKaXyYYE4haQoA=";

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

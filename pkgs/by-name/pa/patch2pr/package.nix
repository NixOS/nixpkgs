{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  patch2pr,
}:

buildGoModule rec {
  pname = "patch2pr";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "bluekeyes";
    repo = "patch2pr";
    rev = "v${version}";
    hash = "sha256-KaU77UYJJqcTJZrFPiqcdzYIVoih6oSeaPWiQdDiZ2s=";
  };

  vendorHash = "sha256-MO6LrUvSu7pYidtjaDgjIEAxoIKM/U9hcePZr336Mbw=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  passthru.tests.patch2pr-version = testers.testVersion {
    package = patch2pr;
    command = "${patch2pr.meta.mainProgram} --version";
    version = version;
  };

  meta = {
    description = "Create pull requests from patches without cloning the repository";
    homepage = "https://github.com/bluekeyes/patch2pr";
    changelog = "https://github.com/bluekeyes/patch2pr/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ katrinafyi ];
    mainProgram = "patch2pr";
  };
}

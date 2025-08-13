{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  patch2pr,
}:

buildGoModule rec {
  pname = "patch2pr";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "bluekeyes";
    repo = "patch2pr";
    rev = "v${version}";
    hash = "sha256-dijSa6BXV8hXuRDeXIHcijPzQKFkmATrlAX0uiDDYjo=";
  };

  vendorHash = "sha256-QEgGq5/JQUIWWmJKoQ832eKhiF5xF8Jivpn1uFDERTA=";

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

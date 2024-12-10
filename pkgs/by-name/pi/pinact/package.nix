{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  pinact,
}:

let
  pname = "pinact";
  version = "0.1.3";
  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "pinact";
    rev = "v${version}";
    hash = "sha256-ifUnF7u4/vMy89xb7sk4tPKQYdFBYAIHc0GYVBMWvWM=";
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-ht4eV62w9AWKYahrd83LmBI+Tu2Q64YA3t90N4BR1e4=";

  doCheck = true;

  passthru.tests.version = testers.testVersion {
    package = pinact;
    command = "pinact --version";
    version = src.rev;
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version} -X main.commit=${src.rev}"
  ];

  meta = with lib; {
    description = "Pin GitHub Actions versions";
    homepage = "https://github.com/suzuki-shunsuke/pinact";
    changelog = "https://github.com/suzuki-shunsuke/pinact/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ maintainers.kachick ];
    mainProgram = "pinact";
  };
}

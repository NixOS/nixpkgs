{ lib
, fetchFromGitHub
, buildGoModule
, testers
, pinact
}:

let
  pname = "pinact";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "pinact";
    rev = "v${version}";
    hash = "sha256-ndlyfp+neoOEzofIlQEQp/6masnzMQFWAPmhan3hlb0=";
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-qu4CHh2013q7e7mBuymlKEhjpdtSOaWGVutjegoVP7E=";

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

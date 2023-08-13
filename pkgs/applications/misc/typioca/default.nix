{ lib
, buildGoModule
, fetchFromGitHub
, testers
, typioca
}:

buildGoModule rec {
  pname = "typioca";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "typioca";
    rev = version;
    hash = "sha256-u/vpS9BQxeKd8eaJicmn2wMk9EYjCO7LXdoshCBa4rw=";
  };

  vendorHash = "sha256-m6hPj1IZr+jEA/h2qbz03tuVq3aPEMmcnWiEC0LKtxI=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/bloznelis/typioca/cmd.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = typioca;
    };
  };

  meta = with lib; {
    description = "Cozy typing speed tester in terminal";
    homepage = "https://github.com/bloznelis/typioca";
    changelog = "https://github.com/bloznelis/typioca/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

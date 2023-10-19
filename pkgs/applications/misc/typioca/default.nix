{ lib
, buildGoModule
, fetchFromGitHub
, testers
, typioca
}:

buildGoModule rec {
  pname = "typioca";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "typioca";
    rev = version;
    hash = "sha256-m6vt4wpLpKJJNP8qCCeLMgNfAAZengDGjBVmFI5ZeSQ=";
  };

  vendorHash = "sha256-q22t4/eum/RSWyzVQfJ0VZkEHgBu12nyRgmkJffi7PM=";

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

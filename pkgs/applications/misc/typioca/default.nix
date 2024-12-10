{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  typioca,
}:

buildGoModule rec {
  pname = "typioca";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "bloznelis";
    repo = "typioca";
    rev = version;
    hash = "sha256-LpQHdqvqAj3gqyvsD58Jhu4GkeJ/R7EjKo7YG7/mmJk=";
  };

  vendorHash = "sha256-lpeceY6ErcxCGKrwVuW19ofsXyfXsJgKGThWKswRTis=";

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
    mainProgram = "typioca";
  };
}

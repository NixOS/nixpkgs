{
  buildGoModule,
  fetchFromGitHub,
  lib,
  curlie,
  testers,
}:

buildGoModule rec {
  pname = "curlie";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YOsq3cB+Pn2eC1Dky3fobBRR7GMxcf/tvWr6i3Vq/BE=";
  };

  patches = [
    ./bump-golang-x-sys.patch
  ];

  vendorHash = "sha256-VsPdMUfS4UVem6uJgFISfFHQEKtIumDQktHQFPC1muc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = curlie;
    command = "curlie version";
  };

  meta = with lib; {
    description = "Frontend to curl that adds the ease of use of httpie, without compromising on features and performance";
    homepage = "https://curlie.io/";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.mit;
    mainProgram = "curlie";
  };
}

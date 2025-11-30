{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubeprompt";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jlesquembre";
    repo = "kubeprompt";
    rev = version;
    hash = "sha256-is6Rz0tw/g4HyGJMTHj+r390HZAytVhfGVRzZ5wKZkU=";
  };

  vendorHash = "sha256-UUMulGnqfIshN2WIejZgwrWWlywj5TpnAQ4A5/d0NCE=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/jlesquembre/kubeprompt/pkg/version.Version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Kubernetes prompt";
    mainProgram = "kubeprompt";
    homepage = "https://github.com/jlesquembre/kubeprompt";
    license = licenses.epl20;
    maintainers = with maintainers; [ jlesquembre ];
  };
}

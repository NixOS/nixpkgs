{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "age-plugin-sss";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "olastor";
    repo = "age-plugin-sss";
    tag = "v${version}";
    hash = "sha256-4cLQRG4Al1C3x/D385kb/aYTlQqe/5bS9oMLJmHOJ1I=";
  };

  vendorHash = "sha256-HQavX6X2k/oABnHXAnOwHNkGpCTr539zRk0xwO8zS9o=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  meta = {
    description = "Age plugin to split keys and wrap them with different recipients using Shamir's Secret Sharing";
    homepage = "https://github.com/olastor/age-plugin-sss/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arbel-arad ];
    mainProgram = "age-plugin-sss";
  };
}

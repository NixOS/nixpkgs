{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "paralus-cli";
  version = "0.1.5";

  src = fetchFromGitHub {
    repo = "cli";
    owner = "paralus";
    rev = "v${version}";
    hash = "sha256-cVrT8wU9MJgc/hzMVe1b0lzm7f+0Prv9w1IjMOAh69E=";
  };

  vendorHash = "sha256-fO+armn5V/dXQfx8fdavohiiutHGGQ/5mRENfDNHCY8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.buildNum=${version}"
  ];

  meta = with lib; {
    description = "Command Line Interface tool for Paralus";
    longDescription = ''
      Paralus is a free, open source tool that enables controlled, audited access to Kubernetes infrastructure.
      It comes with just-in-time service account creation and user-level credential management that integrates
      with your RBAC and SSO. Ships as a GUI, API, and CLI.
    '';
    homepage = "https://www.paralus.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ kashw2 ];
    mainProgram = "paralus";
  };
}

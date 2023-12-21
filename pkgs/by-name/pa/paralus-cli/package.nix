{ lib
, fetchFromGitHub
, buildGoModule
, paralus-cli
, testers
}:

buildGoModule rec {
  pname = "paralus-cli";
  version = "0.1.4";

  src = fetchFromGitHub {
    repo = "cli";
    owner = "paralus";
    rev = "v${version}";
    hash = "sha256-2lTT53VTvwcxYSn9koLKMIc7pmAdrOmeuBvAHjMkqu0=";
  };

  vendorHash = "sha256-M4ur9V2HP/bxG4LzM4xoGdzd4l54pc8pjWiT5GQ3X04=";

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

{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "pget";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Code-Hex";
    repo = "pget";
    rev = "v${version}";
    hash = "sha256-SDe9QH1iSRfMBSCfYiOJPXUbDvxH5cCCWvQq9uTWT9Y=";
  };

  vendorHash = "sha256-p9sgvk5kfim3rApgp++1n05S9XrOWintxJfCeeySuBo=";

  ldflags = [
    "-w"
    "-s"
    "-X=main.version=${version}"
  ];

  meta = with lib; {
    description = "The fast, resumable file download client";
    homepage = "https://github.com/Code-Hex/pget?tab=readme-ov-file";
    license = licenses.mit;
    maintainers = with maintainers; [ Ligthiago ];
    mainProgram = "pget";
  };
}

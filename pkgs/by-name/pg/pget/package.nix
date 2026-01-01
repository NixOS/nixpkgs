{
  lib,
  buildGoModule,
  fetchFromGitHub,
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

<<<<<<< HEAD
  meta = {
    description = "Fast, resumable file download client";
    homepage = "https://github.com/Code-Hex/pget?tab=readme-ov-file";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Ligthiago ];
=======
  meta = with lib; {
    description = "Fast, resumable file download client";
    homepage = "https://github.com/Code-Hex/pget?tab=readme-ov-file";
    license = licenses.mit;
    maintainers = with maintainers; [ Ligthiago ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pget";
  };
}

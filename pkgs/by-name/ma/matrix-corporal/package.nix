{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "matrix-corporal";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "devture";
    repo = pname;
    rev = version;
    sha256 = "sha256-KSKPTbF1hhzLyD+iL4+hW9EuV+xFYzSzHu1DSGXWm90=";
  };

  ldflags = [
    "-s" "-w" "-X main.GitCommit=${version}" "-X main.GitBranch=${version}" "-X main.GitState=nixpkgs" "-X main.GitSummary=${version}" "-X main.Version=${version}"
  ];

  vendorHash = "sha256-sC9JA6VRmHGuO3anaZW2Ih5QnRrUom9IIOE7yi3TTG8=";

  meta = with lib; {
    homepage = "https://github.com/devture/matrix-corporal";
    description = "Reconciliator and gateway for a managed Matrix server";
    maintainers = with maintainers; [ dandellion ];
    mainProgram = "devture-matrix-corporal";
    license = licenses.agpl3Only;
  };
}

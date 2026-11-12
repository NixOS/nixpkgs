{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "matrix-corporal";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "devture";
    repo = "matrix-corporal";
    rev = finalAttrs.version;
    sha256 = "sha256-KSKPTbF1hhzLyD+iL4+hW9EuV+xFYzSzHu1DSGXWm90=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.GitCommit=${finalAttrs.version}"
    "-X main.GitBranch=${finalAttrs.version}"
    "-X main.GitState=nixpkgs"
    "-X main.GitSummary=${finalAttrs.version}"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-sC9JA6VRmHGuO3anaZW2Ih5QnRrUom9IIOE7yi3TTG8=";

  meta = {
    homepage = "https://github.com/devture/matrix-corporal";
    description = "Reconciliator and gateway for a managed Matrix server";
    maintainers = with lib.maintainers; [ dandellion ];
    mainProgram = "devture-matrix-corporal";
    license = lib.licenses.agpl3Only;
  };
})

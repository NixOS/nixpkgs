{
  lib,
  buildGoModule,
  fetchFromGitLab,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "marathon";
  version = "1.00";

  src = fetchFromGitLab {
    owner = "andras.horvath1";
    repo = "marathon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0z0LrsSQFwoJZlMfEGPZei/dhFwOitfNmc7QBlJ+tiM=";
  };

  vendorHash = "sha256-U77l3cmqnseVotXw/qJIbL7ZR2UHkKFPddJ8Q6Q37iE=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage marathon.1
  '';

  meta = {
    description = "Personal task runner for long-running workflows";
    homepage = "https://gitlab.com/andras.horvath1/marathon";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ raas ];
    mainProgram = "marathon";
  };
})

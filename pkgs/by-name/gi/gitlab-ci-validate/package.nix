{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-ci-validate";
  version = "0.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Code0x58";
    repo = "gitlab-ci-validate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j32knPhVio2OTATkW1Z3SMMYwl9u6Lh00Rell/knQ/0=";
  };

  vendorHash = "sha256-/+iu9SIaLtE51xcEzgA8dCp0eTAoPskp4xGlm1bsXTs=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool to validate .gitlab-ci.yml files";
    homepage = "https://github.com/Code0x58/gitlab-ci-validate";
    changelog = "https://github.com/Code0x58/gitlab-ci-validate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "gitlab-ci-validate";
  };
})

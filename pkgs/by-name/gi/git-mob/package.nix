{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-mob";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "mubashwer";
    repo = "git-mob";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0NSGObflI1iiRp/lVkD8RhUKS+He1ERAZUHxcU0EI8M=";
  };

  cargoHash = "sha256-0+JASgFPO7gbIeJmPskPSirMec89qSoa0461SuIxwNA=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ git ];

  checkFlags = [
    "--skip=helpers::tests::test_execute_failure"
    "--skip=helpers::tests::test_execute_success"
  ];

  postInstall = ''
    wrapProgram $out/bin/git-mob \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  meta = {
    description = "CLI tool to help you automatically add Co-authored-by trailers to git commits during pair/mob programming";
    homepage = "https://github.com/mubashwer/git-mob";
    changelog = "https://github.com/mubashwer/git-mob/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
  };
})

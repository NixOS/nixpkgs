{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
  git,
  bash,
}:

buildGoModule (finalAttrs: {
  pname = "soft-serve";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QrLm88lcJRhgJw9RN7m3BsipOFEpAe1weEI5F3u+Bqw=";
  };

  vendorHash = "sha256-Ri/njTAjpVCd/rXQt/ZxNe1iTfDWZb6JzoFipj/1UlA=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # Soft-serve generates git-hooks at run-time.
    # The scripts require git and bash inside the path.
    wrapProgram $out/bin/soft \
      --prefix PATH : "${
        lib.makeBinPath [
          git
          bash
        ]
      }"
  '';

  passthru.tests = nixosTests.soft-serve;

  meta = {
    description = "Tasty, self-hosted Git server for the command line";
    homepage = "https://github.com/charmbracelet/soft-serve";
    changelog = "https://github.com/charmbracelet/soft-serve/releases/tag/v${finalAttrs.version}";
    mainProgram = "soft";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})

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
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IkKS2y0YLLamGxMAIwfD+otZPSJFyT3PyT07whkQaCY=";
  };

  vendorHash = "sha256-SN1SZ/AXRDvyhHmRJJEwycYuqWU1ItB2O1n16nSLdMQ=";

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

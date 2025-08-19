{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
  git,
  bash,
}:

buildGoModule rec {
  pname = "soft-serve";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    rev = "v${version}";
    hash = "sha256-gjkq1Be+x5qZYjO3pWt+u5A2izgMfR3+nxIHTc1ck6Y=";
  };

  vendorHash = "sha256-l0gsStKkfH0TQ1a935LSuFah3BBwVsMD4iSf2oDyViY=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
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
    changelog = "https://github.com/charmbracelet/soft-serve/releases/tag/v${version}";
    mainProgram = "soft";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ penguwin ];
  };
}

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
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    rev = "v${version}";
    hash = "sha256-Ga1RpBkEzuPTu0j+dGg2WX6E3y9hcUJTRPx6XPz4bfk=";
  };

  vendorHash = "sha256-eri/GAsJgsmT73orTawCMS6o/FYCBv33yVb1qA+/LqY=";

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

  meta = with lib; {
    description = "Tasty, self-hosted Git server for the command line";
    homepage = "https://github.com/charmbracelet/soft-serve";
    changelog = "https://github.com/charmbracelet/soft-serve/releases/tag/v${version}";
    mainProgram = "soft";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}

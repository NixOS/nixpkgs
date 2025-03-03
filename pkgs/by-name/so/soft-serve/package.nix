{ lib, buildGoModule, fetchFromGitHub, makeWrapper, nixosTests, git, bash }:

buildGoModule rec {
  pname = "soft-serve";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    rev = "v${version}";
    hash = "sha256-eYe+F/1oiAshQeUQhpf8aUtmy1OWUL00F5SH6tV1NO0=";
  };

  vendorHash = "sha256-DGlenK4CsxhoxtD87KeJYuKG/cpP3MuCCS+7Zlc4WUM=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # Soft-serve generates git-hooks at run-time.
    # The scripts require git and bash inside the path.
    wrapProgram $out/bin/soft \
      --prefix PATH : "${lib.makeBinPath [ git bash ]}"
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

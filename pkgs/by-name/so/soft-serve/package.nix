{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
  git,
  bash,
}:

let
  version = "0.11.3";
in
buildGoModule {
  pname = "soft-serve";
  inherit version;

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    rev = "v${version}";
    hash = "sha256-WugaUfu4X3eEMNKEjIo/um91iI5WeaZmkG/eJ1TPogA=";
  };

  vendorHash = "sha256-qyOBwDSP+roKqi5Khn0ApmtVIgRc/0wB6FVmjzqaZOY=";

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
    maintainers = [ ];
  };
}

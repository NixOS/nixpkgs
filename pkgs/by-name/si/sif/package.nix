{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sif";
  version = "0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "a38ba0abd015894d56d8da67536a4a4bd0dcefe5";
    hash = "sha256-aiiERjeZ7S0fcryIu7dcqks5SIBPlcoasz5H5wuIZG4=";
  };

  vendorHash = "sha256-IMavLk0Sz6Lelj9jkS+fBruSinXiVzX+OWfbqfuwt14=";

  subPackages = [ "cmd/sif" ];

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    # upstream stamps the lowercase main.version, see cmd/sif/main.go
    "-X main.version=${finalAttrs.version}"
  ];

  # network-dependent tests
  doCheck = false;

  postInstall = ''
    installManPage man/sif.1
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=(0-unstable-.*)"
    ];
  };

  meta = {
    description = "Modular pentesting toolkit written in Go";
    homepage = "https://github.com/vmfunc/sif";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vmfunc ];
    mainProgram = "sif";
  };
})

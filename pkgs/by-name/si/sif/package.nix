{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sif";
  version = "0-unstable-2026-07-03";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "7ea1cd28d5b535b8ea7826de9100e12907bc2fd0";
    hash = "sha256-1gyfWJVuuEdW87DBZ++NX/pSoA12l+Ju3n5TVDzfnoo=";
  };

  vendorHash = "sha256-ftnEHvnjdJpViEXS3nLK8nRmJRBLzjzqMZKPVvlzRDk=";

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

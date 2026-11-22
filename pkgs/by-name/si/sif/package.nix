{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sif";
  version = "0-unstable-2026-11-07";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "5ed3a4c4719f6cd7aea5eef9339e557c90670103";
    hash = "sha256-ZNoQ3sj77cfSHSYNKYnN/N1LdocDNFeh/i5szeOCn1I=";
  };

  vendorHash = "sha256-MRxcKDkyjXr7VsxWQVxSJfd+MyUlsTSAalmb2AaLIbY=";

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

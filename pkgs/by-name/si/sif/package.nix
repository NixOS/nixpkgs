{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sif";
  version = "0-unstable-2026-10-09";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "f98638f11dfbb76ea8f98e430c5580142504c0ee";
    hash = "sha256-q1ws79Fe0Vzp/vt7kPE2hrtTKPr8PUDOXUQTm04gsxA=";
  };

  vendorHash = "sha256-3TF9LNTDAjm81w7AMo0YZXN3FInFNw5T0ZMXGjk2cTQ=";

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

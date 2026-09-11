{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sif";
  version = "0-unstable-2026-08-22";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "e9d578a7450b70e33b9ebf43ac0ef6c06fde062b";
    hash = "sha256-TtFTgu3lJXIUfIH+BY6DHSm1CQcFmZ3tJuraYmh5el8=";
  };

  vendorHash = "sha256-AS+nZSM0Fnv4vs08OMLCM8jZXeE9bH4Vj/V+sfpbqRE=";

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

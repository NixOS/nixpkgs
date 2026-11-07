{
  stdenv,
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  testers,
  goreleaser,
}:
buildGo127Module (finalAttrs: {
  pname = "goreleaser";
  version = "2.20.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "goreleaser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RVuLoFiApR4zYL1qlCtPO8Qm1iRtQVRYAFEUFrmKTXQ=";
  };

  vendorHash = "sha256-d/WZfWzUVe2yJEbHuaMAuiJnuOCDsCfcnGFiQcMU954=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.builtBy=nixpkgs"
  ];

  subPackages = [
    "."
  ];

  # tests expect the source files to be a build repo
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      ${emulator} $out/bin/goreleaser man > goreleaser.1
      installManPage ./goreleaser.1
      installShellCompletion --cmd goreleaser \
        --bash <(${emulator} $out/bin/goreleaser completion bash) \
        --fish <(${emulator} $out/bin/goreleaser completion fish) \
        --zsh  <(${emulator} $out/bin/goreleaser completion zsh)
    '';

  passthru.tests.version = testers.testVersion {
    package = goreleaser;
    command = "goreleaser -v";
    inherit (finalAttrs) version;
  };

  meta = {
    description = "Deliver Go binaries as fast and easily as possible";
    homepage = "https://goreleaser.com";
    maintainers = with lib.maintainers; [
      sarcasticadmin
      techknowlogick
      caarlos0
      anthr76
    ];
    license = lib.licenses.mit;
    mainProgram = "goreleaser";
  };
})

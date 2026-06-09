{
  stdenv,
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  testers,
  goreleaser,
}:
buildGo126Module (finalAttrs: {
  pname = "goreleaser";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "goreleaser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TV03T9OZXiEa4+v1teI9YA2ilDEU4RoDY9kGdENfZqU=";
  };

  vendorHash = "sha256-9an5C6xLxyiC4pejOZlz40ZNdc6c0A1mvekXefrCTeQ=";

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
    ];
    license = lib.licenses.mit;
    mainProgram = "goreleaser";
  };
})

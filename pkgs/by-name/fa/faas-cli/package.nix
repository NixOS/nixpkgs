{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  git,
  installShellFiles,
  testers,
  faas-cli,
}:
let
  faasPlatform =
    platform:
    let
      cpuName = platform.parsed.cpu.name;
    in
    {
      "aarch64" = "arm64";
      "armv7l" = "armhf";
      "armv6l" = "armhf";
    }
    .${cpuName} or cpuName;
in
buildGoModule (finalAttrs: {
  pname = "faas-cli";
  version = "0.18.12";

  src = fetchFromGitHub {
    owner = "openfaas";
    repo = "faas-cli";
    rev = finalAttrs.version;
    sha256 = "sha256-I7P30c7rEVqemgUu/1AtM6jq2f4KB8xyDpjGBMvkLRU=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openfaas/faas-cli/version.GitCommit=ref/tags/${finalAttrs.version}"
    "-X github.com/openfaas/faas-cli/version.Version=${finalAttrs.version}"
    "-X github.com/openfaas/faas-cli/commands.Platform=${faasPlatform stdenv.hostPlatform}"
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postInstall = ''
    wrapProgram "$out/bin/faas-cli" \
      --prefix PATH : ${lib.makeBinPath [ git ]}

    installShellCompletion --cmd metal \
      --bash <($out/bin/faas-cli completion --shell bash) \
      --zsh <($out/bin/faas-cli completion --shell zsh)
  '';

  passthru.tests.version = testers.testVersion {
    command = "${faas-cli}/bin/faas-cli version --short-version --warn-update=false";
    package = faas-cli;
  };

  meta = {
    description = "Official CLI for OpenFaaS";
    mainProgram = "faas-cli";
    homepage = "https://github.com/openfaas/faas-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      welteki
      techknowlogick
    ];
  };
})

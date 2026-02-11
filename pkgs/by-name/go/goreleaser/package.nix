{
  stdenv,
  lib,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  testers,
  goreleaser,
}:
buildGo125Module rec {
  pname = "goreleaser";
  version = "2.13.3";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "goreleaser";
    rev = "v${version}";
    hash = "sha256-VlpBz2FguUfN+ssv+PLSB9RDgLKGP2V/0pAxaLNGu7w=";
  };

  vendorHash = "sha256-UiQ8JH6ISOmo5rQzxE1Zf4jU8VXtI29GsZFTINokLo8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
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
    inherit version;
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
}

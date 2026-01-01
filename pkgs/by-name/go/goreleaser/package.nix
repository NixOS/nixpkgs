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
<<<<<<< HEAD
  version = "2.13.0";
=======
  version = "2.12.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "goreleaser";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Z0DadF4wiDwykr0NIhL/IbwARwTjMXQDYmQevvjN2W8=";
  };

  vendorHash = "sha256-pDu3ZYQQEhSugOUGD2Xi5mBJRjOWr3AWKS/PPy1MEvs=";
=======
    hash = "sha256-McLE7o5eUTluIOlsArIo5Dh7fizxxCMVAdXXnSBKhQU=";
  };

  vendorHash = "sha256-M8+KJV7LemD6AHjJS8nZ70AZ30kZIgyYQv/yWB3lmsw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Deliver Go binaries as fast and easily as possible";
    homepage = "https://goreleaser.com";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Deliver Go binaries as fast and easily as possible";
    homepage = "https://goreleaser.com";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      sarcasticadmin
      techknowlogick
      caarlos0
    ];
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "goreleaser";
  };
}

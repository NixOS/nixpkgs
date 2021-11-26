{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qemu
, makeWrapper
}:

buildGoModule rec {
  pname = "lima";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pn8GtFAZMQyFjOpn6blNBoDgQL7X1gaYjGsQHwvMzaQ=";
  };

  vendorSha256 = "sha256-egZFJSGnFYfOcBMNNEsPV6ngf3ddoYCSntnuloYfpxo=";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildPhase = ''
    runHook preBuild
    make "VERSION=v${version}" binaries
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r _output/* $out
    wrapProgram $out/bin/limactl \
      --prefix PATH : ${lib.makeBinPath [ qemu ]}
    installShellCompletion --cmd limactl \
      --bash <($out/bin/limactl completion bash) \
      --fish <($out/bin/limactl completion fish) \
      --zsh <($out/bin/limactl completion zsh)
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    USER=nix $out/bin/limactl validate examples/default.yaml
  '';

  meta = with lib; {
    homepage = "https://github.com/lima-vm/lima";
    description = "Linux virtual machines (on macOS, in most cases)";
    license = licenses.asl20;
    maintainers = with maintainers; [ anhduy ];
  };
}

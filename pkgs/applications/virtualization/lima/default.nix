{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qemu
, makeWrapper
}:

buildGoModule rec {
  pname = "lima";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DN8YXbpD7TVVPvl8LKAwLHKt50G37cu8dJBqF+DDE6g=";
  };

  vendorSha256 = "sha256-lrJVnWd94nELROP5VYI+Qs8cK5U9PYiZo9j9cusb9cY=";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  # clean fails with read only vendor dir
  postPatch = ''
    substituteInPlace Makefile --replace 'binaries: clean' 'binaries:'
  '';

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

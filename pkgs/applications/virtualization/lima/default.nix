{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qemu
, makeWrapper
}:

buildGoModule rec {
  pname = "lima";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xlpNJjSBw1iL8CjbWE6v4u7Vq5PjkGv0tQKU5eRN13w=";
  };

  vendorSha256 = "sha256-uTkCi969RQ4K0ZJ2vOgqv3OJgzVVRX7b2sXNfmR6qoA=";

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

{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qemu
, makeWrapper
}:

buildGoModule rec {
  pname = "lima";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kSJbSJ85cM6N+V67z+trNNuEO4O2KNs62JTy3Mz8Bi4=";
  };

  vendorSha256 = "sha256-PeIEIUX/PwwnbZfXnK3IsENO+zRYLhljBRe910aZgKs=";

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
      --bash <($out/bin/limactl completion bash)
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


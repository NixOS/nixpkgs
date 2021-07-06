{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qemu
, makeWrapper
}:

buildGoModule rec {
  pname = "lima";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "AkihiroSuda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1952xGSfVFI2Fs5HLJKCyB6ZxKFf5uPKXIlctM/T+8o=";
  };

  vendorSha256 = "sha256-rPL/jxMHMkKffoYLSI3FFtFRYGtARKmrODmL9w+rN0E=";

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
    homepage = "https://github.com/AkihiroSuda/lima";
    description = "Linux virtual machines (on macOS, in most cases)";
    license = licenses.asl20;
    maintainers = with maintainers; [ anhduy ];
  };
}


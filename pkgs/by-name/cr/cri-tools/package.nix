{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "cri-tools";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cri-tools";
    rev = "v${version}";
    hash = "sha256-nWbxPw8lz1FYLHXJ2G4kzOl5nBPXSl4nEJ9KgzS/wmA=";
  };

  vendorHash = null;

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild
    make binaries VERSION=${version}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install BINDIR=$out/bin
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd crictl \
        --$shell <($out/bin/crictl completion $shell)
    done
  ''
  + ''
    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI and validation tools for Kubelet Container Runtime Interface (CRI)";
    homepage = "https://github.com/kubernetes-sigs/cri-tools";
    license = licenses.asl20;
    teams = [ teams.podman ];
  };
}

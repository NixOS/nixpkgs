{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "cri-tools";
<<<<<<< HEAD
  version = "1.35.0";
=======
  version = "1.34.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cri-tools";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-66UDoObxlNBTYJPpo4GoQlV66hXZRf5eLB3ji0KU/Zs=";
=======
    hash = "sha256-nWbxPw8lz1FYLHXJ2G4kzOl5nBPXSl4nEJ9KgzS/wmA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "CLI and validation tools for Kubelet Container Runtime Interface (CRI)";
    homepage = "https://github.com/kubernetes-sigs/cri-tools";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
=======
  meta = with lib; {
    description = "CLI and validation tools for Kubelet Container Runtime Interface (CRI)";
    homepage = "https://github.com/kubernetes-sigs/cri-tools";
    license = licenses.asl20;
    teams = [ teams.podman ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

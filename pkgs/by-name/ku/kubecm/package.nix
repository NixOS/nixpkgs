{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "kubecm";
<<<<<<< HEAD
  version = "0.34.0";
=======
  version = "0.33.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-UPjo21tbPCC+l6aWrTcYZEJ9a1k8/kJ7anBHWZSkYwI=";
  };

  vendorHash = "sha256-P+CkGgMCDpW/PaGFljj+WRxfeieuTFax6xvNq6p8lHw=";
=======
    hash = "sha256-pezn1s2IvAfVbF8b5jJ4uoVNi5g/2OfUuE4YXrK0gZk=";
  };

  vendorHash = "sha256-HKHUN3vOhNl46T06pMUZIjcZMxDw/gkeimbs7kdmtdI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ldflags = [
    "-s"
    "-w"
    "-X github.com/sunny0826/kubecm/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kubecm \
      --bash <($out/bin/kubecm completion bash) \
      --fish <($out/bin/kubecm completion fish) \
      --zsh <($out/bin/kubecm completion zsh)
  '';

  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      qjoly
      sailord
    ];
    mainProgram = "kubecm";
  };
}

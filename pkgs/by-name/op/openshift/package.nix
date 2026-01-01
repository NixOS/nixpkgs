{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gpgme,
  installShellFiles,
  pkg-config,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "openshift";
  version = "4.19.0-202505210330";
  gitCommit = "8f1c8b5";
=======
  testers,
  openshift,
}:
buildGoModule rec {
  pname = "openshift";
  version = "4.16.0";
  gitCommit = "fa84651";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "oc";
<<<<<<< HEAD
    tag = "openshift-clients-${finalAttrs.version}";
    hash = "sha256-EIsK73zSozqBOFZalURNcamk5FRDusUEhXtup60c2zQ=";
=======
    rev = "fa846511dbeb7e08cf77265056397283c6c896f9";
    hash = "sha256-mGItCpZQqQOKoNm2amwpHrEIcZdVNirQFa7DGvmnR9s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = null;

  buildInputs = [ gpgme ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X github.com/openshift/oc/pkg/version.commitFromGit=${finalAttrs.gitCommit}"
    "-X github.com/openshift/oc/pkg/version.versionFromGit=v${finalAttrs.version}"
=======
    "-X github.com/openshift/oc/pkg/version.commitFromGit=${gitCommit}"
    "-X github.com/openshift/oc/pkg/version.versionFromGit=v${version}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  doCheck = false;

  postInstall = ''
    # Install man pages.
    mkdir -p man
    $out/bin/genman man oc
    installManPage man/*.1

    # Remove unwanted tooling.
    rm $out/bin/clicheck $out/bin/gendocs $out/bin/genman

    # Install shell completions.
    installShellCompletion --cmd oc \
      --bash <($out/bin/oc completion bash) \
      --fish <($out/bin/oc completion fish) \
      --zsh <($out/bin/oc completion zsh)
  '';

<<<<<<< HEAD
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    homepage = "http://www.openshift.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  passthru.tests.version = testers.testVersion {
    package = openshift;
    command = "oc version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    homepage = "http://www.openshift.org";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      offline
      moretea
      stehessel
    ];
    mainProgram = "oc";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

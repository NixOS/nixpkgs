{ lib
, buildGoModule
, fetchFromGitHub
, gpgme
, installShellFiles
<<<<<<< HEAD
, pkg-config
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, testers
, openshift
}:
buildGoModule rec {
  pname = "openshift";
<<<<<<< HEAD
  version = "4.13.0";
  gitCommit = "e561d37";
=======
  version = "4.12.0";
  gitCommit = "854f807";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "oc";
<<<<<<< HEAD
    rev = "e561d37285c8bde273ce00d086bea599a9cdd3be";
    hash = "sha256-/ar96N+MSy0DPdza3UWiyolg1EZPBR6LCku4GV+HppM=";
=======
    rev = "854f807d8a84dde710c062a5281bca5bc07cb562";
    hash = "sha256-GH3LjAeMIHmFbJoKGoeeNteP4Ma2+kIC5rAxObdziKg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  buildInputs = [ gpgme ];

<<<<<<< HEAD
  nativeBuildInputs = [ installShellFiles pkg-config ];
=======
  nativeBuildInputs = [ installShellFiles ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openshift/oc/pkg/version.commitFromGit=${gitCommit}"
    "-X github.com/openshift/oc/pkg/version.versionFromGit=v${version}"
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

  passthru.tests.version = testers.testVersion {
    package = openshift;
    command = "oc version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    homepage = "http://www.openshift.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline bachp moretea stehessel ];
    mainProgram = "oc";
    platforms = platforms.unix;
  };
}

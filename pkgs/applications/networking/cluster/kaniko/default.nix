{ stdenv
, lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
, testers
, kaniko
}:

buildGoModule rec {
  pname = "kaniko";
<<<<<<< HEAD
  version = "1.15.0";
=======
  version = "1.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "kaniko";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-PNAqdeB/ya3i1hRbagpfmpwS0tNRZbWBm9YIXME1HMc=";
=======
    hash = "sha256-dXQ0/o1qISv+sjNVIpfF85bkbM9sGOGwqVbWZpMWfMY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  ldflags = [
    "-s" "-w"
    "-X github.com/GoogleContainerTools/kaniko/pkg/version.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false; # requires docker, container-diff (unpackaged yet)

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    for shell in bash fish zsh; do
      $out/bin/executor completion $shell > executor.$shell
      installShellCompletion executor.$shell
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = kaniko;
    version = version;
    command = "${kaniko}/bin/executor version";
  };

  meta = {
    description = "A tool to build container images from a Dockerfile, inside a container or Kubernetes cluster";
    homepage = "https://github.com/GoogleContainerTools/kaniko";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ jk qjoly ];
=======
    maintainers = with lib.maintainers; [ jk ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "executor";
  };
}

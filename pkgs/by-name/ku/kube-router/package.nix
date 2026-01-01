{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kube-router,
}:

buildGoModule rec {
  pname = "kube-router";
<<<<<<< HEAD
  version = "2.6.3";
=======
  version = "2.6.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cloudnativelabs";
    repo = "kube-router";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-0UuUDIIDedHDo2gVNg/4Ilcyw7BzUCJFdhn/GOi5QNs=";
=======
    hash = "sha256-VGbjXjBhfsgIW0uIP8I8KRb4J/+4SRJBpN5ebRP40EY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-fXZ6jRlFdjYPV5wqSdWAMlHj1dkkEpbCtcKMuuoje1U=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cloudnativelabs/kube-router/v2/pkg/version.Version=${version}"
    "-X github.com/cloudnativelabs/kube-router/v2/pkg/version.BuildDate=Nix"
  ];

  passthru.tests.version = testers.testVersion {
    package = kube-router;
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://www.kube-router.io/";
    description = "All-in-one router, firewall and service proxy for Kubernetes";
    mainProgram = "kube-router";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ johanot ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://www.kube-router.io/";
    description = "All-in-one router, firewall and service proxy for Kubernetes";
    mainProgram = "kube-router";
    license = licenses.asl20;
    maintainers = with maintainers; [ johanot ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

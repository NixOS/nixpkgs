{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, btrfs-progs
, testers
, werf
}:

buildGoModule rec {
  pname = "werf";
<<<<<<< HEAD
  version = "1.2.253";
=======
  version = "1.2.231";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "werf";
    repo = "werf";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cHMMLV2NdYueL3qV0wpB4n0+2XZTvg4mfKTSgGZHqqY=";
  };

  vendorHash = "sha256-vuEqimNRWQGwybzOkGVoevpyVpU8XyXqhAIa7I66ajs=";
=======
    hash = "sha256-tiIfdODyUH3RoB1Htono2ZgN8+kiM1BXpNPn2B9V/mk=";
  };

  vendorHash = "sha256-SRNxV3zRYfbMJB4iGic3lu25VXIrl5011rB6AYqZG8U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  proxyVendor = true;

  subPackages = [ "cmd/werf" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isLinux [ btrfs-progs ]
    ++ lib.optionals stdenv.hostPlatform.isGnu [ stdenv.cc.libc.static ];

  CGO_ENABLED = if stdenv.isLinux then 1 else 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/werf/werf/pkg/werf.Version=${src.rev}"
  ] ++ lib.optionals (CGO_ENABLED == 1) [
    "-extldflags=-static"
    "-linkmode external"
  ];

  tags = [
    "containers_image_openpgp"
    "dfrunmount"
    "dfrunnetwork"
    "dfrunsecurity"
    "dfssh"
  ] ++ lib.optionals (CGO_ENABLED == 1) [
    "exclude_graphdriver_devicemapper"
    "netgo"
    "no_devmapper"
    "osusergo"
    "static_build"
  ];

  preCheck = ''
    # Test all targets.
    unset subPackages

    # Remove tests that require external services.
    rm -rf \
      integration/suites \
      pkg/true_git/*test.go \
      test/e2e
<<<<<<< HEAD
=======

    # Remove failing tests.
    rm -rf \
      cmd/werf/docs/replacers/kubectl/kubectl_test.go
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '' + lib.optionalString (CGO_ENABLED == 0) ''
    # A workaround for osusergo.
    export USER=nixbld
  '';

  postInstall = ''
    installShellCompletion --cmd werf \
      --bash <($out/bin/werf completion --shell=bash) \
      --zsh <($out/bin/werf completion --shell=zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = werf;
    command = "werf version";
    version = src.rev;
  };

  meta = with lib; {
    description = "GitOps delivery tool";
    longDescription = ''
      The CLI tool gluing Git, Docker, Helm & Kubernetes with any CI system to
      implement CI/CD and Giterminism.
    '';
    homepage = "https://werf.io";
    changelog = "https://github.com/werf/werf/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
  };
}

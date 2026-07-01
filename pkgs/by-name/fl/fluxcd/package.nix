{
  buildGoModule,
  fetchFromGitHub,
  fetchzip,
  installShellFiles,
  lib,
  stdenv,
  writableTmpDirAsHomeHook,
}:

let
  version = "2.8.8";
  srcHash = "sha256-ECFEzYhnhse2yrfWYaeN5dE+HUvCy5RKZ2OceCb5+sA=";
  vendorHash = "sha256-pV7eoiGhWk6KYZbK8bamXJY/NdK7ZYqrVcCTX9ccLJc=";
  manifestsHash = "sha256-fF21nDstKUrlW6fgm0DrDtntR/0cnHMEzRltjBm9nwA=";

  manifests = fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v${version}/manifests.tar.gz";
    hash = manifestsHash;
    stripRoot = false;
  };
in

buildGoModule rec {
  pname = "fluxcd";
  inherit vendorHash version;

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    rev = "v${version}";
    hash = srcHash;
  };

  postUnpack = ''
    cp -r ${manifests} source/cmd/flux/manifests

    # disable tests that require network access
    rm source/cmd/flux/create_secret_git_test.go
  '';

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  subPackages = [ "cmd/flux" ];

  nativeBuildInputs = [ installShellFiles ];

  # Required to workaround test error:
  #   panic: mkdir /homeless-shelter: permission denied
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/flux --version | grep ${version} > /dev/null
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd flux \
        --$shell <($out/bin/flux completion $shell)
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/fluxcd/flux2/releases/tag/v${version}";
    description = "Open and extensible continuous delivery solution for Kubernetes";
    downloadPage = "https://github.com/fluxcd/flux2/";
    longDescription = ''
      Flux is a tool for keeping Kubernetes clusters in sync
      with sources of configuration (like Git repositories), and automating
      updates to configuration when there is new code to deploy.
    '';
    homepage = "https://fluxcd.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jlesquembre
      ryan4yin
      SchahinRohani
      stealthybox
    ];
    mainProgram = "flux";
  };
}

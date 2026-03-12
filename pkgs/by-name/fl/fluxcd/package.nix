{
  buildGoModule,
  fetchFromGitHub,
  fetchzip,
  installShellFiles,
  lib,
  stdenv,
  writableTmpDirAsHomeHook,
  go_1_26,
}:

let
  version = "2.8.1";
  srcHash = "sha256-TuXkG54ohsfHMw1VXsYnepZkMx1ZbMHaog+XPxN5F+8=";
  vendorHash = "sha256-nzNVH4Vm1p7PwtOqej+RfgjpONpxCrZdqjY6x3f/uog=";
  manifestsHash = "sha256-qo0szujGP2eL48KYjnft2Iu95Y/uH2/bSNETvnpVGYE=";

  manifests = fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v${version}/manifests.tar.gz";
    hash = manifestsHash;
    stripRoot = false;
  };
in

buildGoModule.override { go = go_1_26; } rec {
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
      superherointj
    ];
    mainProgram = "flux";
  };
}

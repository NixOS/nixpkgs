{
  # Version 1.27 override necessary because it is not yet the default.
  buildGo127Module,
  fetchFromGitHub,
  fetchzip,
  installShellFiles,
  lib,
  stdenv,
  writableTmpDirAsHomeHook,
}:

let
  version = "2.10.0";
  srcHash = "sha256-BE8uDHDMaOOEFOb6UEIH8L5uzVKn/Eybf2fynLkD2Pc=";
  vendorHash = "sha256-l/4P92/8tpBuQodAw6aHpGpm1sm/t0a605CUyVRdxKY=";
  manifestsHash = "sha256-61BEm2D20+Ssczu72Wle80+5ZitHqRBnQshS8Ia+7Bg=";

  manifests = fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v${version}/manifests.tar.gz";
    hash = manifestsHash;
    stripRoot = false;
  };
in

buildGo127Module (finalAttrs: {
  pname = "fluxcd";
  inherit vendorHash version;

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    rev = "v${finalAttrs.version}";
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
    "-X main.VERSION=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/flux" ];

  nativeBuildInputs = [ installShellFiles ];

  # Required to workaround test error:
  #   panic: mkdir /homeless-shelter: permission denied
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # TestPluginSearch and TestPluginSearchErrors start a local HTTP server for the tests.
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/flux --version | grep ${finalAttrs.version} > /dev/null
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd flux \
        --$shell <($out/bin/flux completion $shell)
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/fluxcd/flux2/releases/tag/v${finalAttrs.version}";
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
      videl
    ];
    mainProgram = "flux";
  };
})

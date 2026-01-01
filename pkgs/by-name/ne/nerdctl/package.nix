{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  buildkit,
  cni-plugins,
<<<<<<< HEAD
  writableTmpDirAsHomeHook,
  versionCheckHook,
  extraPackages ? [ ],
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nerdctl";
  version = "2.2.0";
=======
  extraPackages ? [ ],
}:

buildGoModule rec {
  pname = "nerdctl";
  version = "1.7.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "nerdctl";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-M3np4NfzEfMt4ii7Fdbdt+y1K7lSTWrqA9Bl+zpzxog=";
  };

  vendorHash = "sha256-cnusyughQitdvYhHtuvCGS9/LdI/ku7DETBdAWttKsY=";
=======
    rev = "v${version}";
    hash = "sha256-GHFs8QvLcXu+DZ851TCLI7EVc9wMS5fRC4TYBXzyv3Q=";
  };

  vendorHash = "sha256-5LRsT04T/CKv+YHaiM2g6giimWWXyzPju3iZuj2DfAY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
<<<<<<< HEAD
    writableTmpDirAsHomeHook
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  ldflags =
    let
<<<<<<< HEAD
      t = "github.com/containerd/nerdctl/v${lib.versions.major finalAttrs.version}/pkg/version";
=======
      t = "github.com/containerd/nerdctl/pkg/version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    in
    [
      "-s"
      "-w"
<<<<<<< HEAD
      "-X ${t}.Version=v${finalAttrs.version}"
      "-X ${t}.Revision=<unknown>"
    ];

  # testing framework which we don't need and can't be build as it is an extra go application
  excludedPackages = [ "mod/tigron" ];

=======
      "-X ${t}.Version=v${version}"
      "-X ${t}.Revision=<unknown>"
    ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # Many checks require a containerd socket and running nerdctl after it's built
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/nerdctl \
      --prefix PATH : "${lib.makeBinPath ([ buildkit ] ++ extraPackages)}" \
      --prefix CNI_PATH : "${cni-plugins}/bin"

    installShellCompletion --cmd nerdctl \
      --bash <($out/bin/nerdctl completion bash) \
      --fish <($out/bin/nerdctl completion fish) \
      --zsh <($out/bin/nerdctl completion zsh)
  '';

  doInstallCheck = true;
<<<<<<< HEAD
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^v([0-9.]+)$" ];
    };
  };

  meta = {
    homepage = "https://github.com/containerd/nerdctl/";
    changelog = "https://github.com/containerd/nerdctl/releases/tag/v${finalAttrs.version}";
=======
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nerdctl --help
    $out/bin/nerdctl --version | grep "nerdctl version ${version}"
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/containerd/nerdctl/";
    changelog = "https://github.com/containerd/nerdctl/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Docker-compatible CLI for containerd";
    mainProgram = "nerdctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      developer-guy
      jk
    ];
    platforms = lib.platforms.linux;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

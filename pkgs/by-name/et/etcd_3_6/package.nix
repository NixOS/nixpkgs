{
  applyPatches,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  k3s,
  lib,
  nixosTests,
  stdenv,
  symlinkJoin,
}:

let
  version = "3.6.9";
  etcdSrcHash = "sha256-6rNCfjfs/lwiF3rnq5IM8ohW8Gz9r6gFHhIu9kvJ8VA=";
  etcdCtlVendorHash = "sha256-yUA28nP5ueJz/b7spbg1mFRs2doBIyVNuZMCMlf//AE=";
  etcdUtlVendorHash = "sha256-E3AVaUVulVKWGRbj/v2owbqkIfvxo/5naN1sNd96z+s=";
  etcdServerVendorHash = "sha256-HtAsmsdjBbqls0S80E08PZcZYFlfpKUYrgJunRFP8Gc=";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "etcd-io";
      repo = "etcd";
      tag = "v${version}";
      hash = etcdSrcHash;
    };
  };

  env = {
    CGO_ENABLED = 0;
  };

  meta = {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    downloadPage = "https://github.com/etcd-io/etcd";
    license = lib.licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with lib.maintainers; [ dtomvan ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };

  etcdserver = buildGoModule {
    pname = "etcdserver";

    inherit
      env
      meta
      src
      version
      ;

    vendorHash = etcdServerVendorHash;

    __darwinAllowLocalNetworking = true;

    modRoot = "./server";

    preInstall = ''
      mv $GOPATH/bin/{server,etcd}
    '';

    # We set the GitSHA to `GitNotFound` to match official build scripts when
    # git is unavailable. This is to avoid doing a full Git Checkout of etcd.
    # User facing version numbers are still available in the binary, just not
    # the sha it was built from.
    ldflags = [ "-X go.etcd.io/etcd/api/v3/version.GitSHA=GitNotFound" ];
  };

  etcdutl = buildGoModule {
    pname = "etcdutl";

    inherit
      env
      meta
      src
      version
      ;

    vendorHash = etcdUtlVendorHash;

    __darwinAllowLocalNetworking = true;

    modRoot = "./etcdutl";

    nativeBuildInputs = [ installShellFiles ];

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for shell in bash fish zsh; do
        installShellCompletion --cmd etcdutl \
          --$shell <($out/bin/etcdutl completion $shell)
      done
    '';
  };

  etcdctl = buildGoModule {
    pname = "etcdctl";

    inherit
      env
      meta
      src
      version
      ;

    vendorHash = etcdCtlVendorHash;

    modRoot = "./etcdctl";

    nativeBuildInputs = [ installShellFiles ];

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for shell in bash fish zsh; do
        installShellCompletion --cmd etcdctl \
          --$shell <($out/bin/etcdctl completion $shell)
      done
    '';
  };
in
symlinkJoin {
  name = "etcd-${version}";

  inherit meta version;

  passthru = {
    deps = {
      inherit etcdserver etcdutl etcdctl;
    };
    tests = nixosTests.etcd."3_6";
    updateScript = ./update.sh;
  };

  paths = [
    etcdserver
    etcdutl
    etcdctl
  ];
}

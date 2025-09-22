{
  applyPatches,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  k3s,
  lib,
  nixosTests,
  stdenv,
  symlinkJoin,
}:

let
  version = "3.6.4";
  etcdSrcHash = "sha256-otz+06cOD2MVnMZWKId1GN+MeZfnDbdudiYfVCKdzuo=";
  etcdCtlVendorHash = "sha256-kTH+s/SY+xwo6kt6iPJ7XDhin0jPk0FBr0eOe/717bE=";
  etcdUtlVendorHash = "sha256-P0yx9YMMD9vT7N6LOlo26EAOi+Dj33p3ZjAYEoaL19A=";
  etcdServerVendorHash = "sha256-kgbCT1JxI98W89veCItB7ZfW4d9D3/Ip3tOuFKEX9v4=";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "etcd-io";
      repo = "etcd";
      tag = "v${version}";
      hash = etcdSrcHash;
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/etcd-io/etcd/commit/31650ab0c8df43af05fc4c13b48ffee59271eec7.patch";
        hash = "sha256-Q94HOLFx2fnb61wMQsAUT4sIBXfxXqW9YEayukQXX18=";
      })
    ];
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
    # Fix-Me: Tests for etcd 3.6 needs work.
    # tests = {
    #   inherit (nixosTests) etcd etcd-cluster;
    #   k3s = k3s.passthru.tests.etcd;
    # };
    updateScript = ./update.sh;
  };

  paths = [
    etcdserver
    etcdutl
    etcdctl
  ];
}

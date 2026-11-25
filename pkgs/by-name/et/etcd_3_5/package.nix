{
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  lib,
  nixosTests,
  symlinkJoin,
}:

let
  version = "3.5.36";
  etcdSrcHash = "sha256-N23S8s5q01UqbljYHotooEUyh/U15coB6cdl7fX+PHA=";
  etcdServerVendorHash = "sha256-2ldY7t0mtaabGBThJTpm7kaOlLKyZEhpqgEMEbOm2jA=";
  etcdUtlVendorHash = "sha256-UHTzwQfql9AEj24X1EuwFN6srH8wZxF5sXrFev6Y1VE=";
  etcdCtlVendorHash = "sha256-eGvoL124b8827S8lSfwWBqDoHp7FdI8zNoGDaWOK2Es=";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    tag = "v${version}";
    hash = etcdSrcHash;
  };

  env = {
    CGO_ENABLED = 0;
  };

  meta = {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
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

    __darwinAllowLocalNetworking = true;

    vendorHash = etcdServerVendorHash;

    modRoot = "./server";

    patches = [
      (fetchpatch {
        name = "go_1_27.patch";
        url = "https://github.com/etcd-io/etcd/commit/b5b40fba5e69f6662fff673d1ffe5c2ce2e3b863.patch";
        includes = [
          "server/embed/config_test.go"
        ];
        hash = "sha256-mNboTMWuK9Y6/7bBXflOcxGIPnBjTqIctBKNXgKzSCU=";
      })
    ];

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

    modRoot = "./etcdutl";
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
  };
in
symlinkJoin {
  pname = "etcd";

  inherit meta version;

  passthru = {
    deps = {
      inherit etcdserver etcdutl etcdctl;
    };
    tests = nixosTests.etcd."3_5";
    updateScript = ./update.sh;
  };

  paths = [
    etcdserver
    etcdutl
    etcdctl
  ];
}

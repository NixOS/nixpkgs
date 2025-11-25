{
  buildGo124Module,
  fetchFromGitHub,
  k3s,
  lib,
  nixosTests,
  symlinkJoin,
}:

let
  version = "3.5.25";
  etcdSrcHash = "sha256-7fCvlp/EG1SofsLC8il/twjg0rEaB/lhz6dnUxgLXik=";
  etcdServerVendorHash = "sha256-R78j1BTuY3ORQiMnm2kWJGnK4jJi7am4x0udW4jjcCE=";
  etcdUtlVendorHash = "sha256-J+/QgRAU1uk9LXdW8b6AhitFlxx/QU7IkJ+5Jez9MkM=";
  etcdCtlVendorHash = "sha256-IiggECH1iFkb51MTeFSFnVbVVDUR1KgsQcbxz9IR4c4=";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    tag = "v${version}";
    hash = etcdSrcHash;
  };

  env = {
    CGO_ENABLED = 0;
  };

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [
      dtomvan
    ];
    platforms = platforms.darwin ++ platforms.linux;
  };

  etcdserver = buildGo124Module {
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

    preInstall = ''
      mv $GOPATH/bin/{server,etcd}
    '';

    # We set the GitSHA to `GitNotFound` to match official build scripts when
    # git is unavailable. This is to avoid doing a full Git Checkout of etcd.
    # User facing version numbers are still available in the binary, just not
    # the sha it was built from.
    ldflags = [ "-X go.etcd.io/etcd/api/v3/version.GitSHA=GitNotFound" ];
  };

  etcdutl = buildGo124Module {
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

  etcdctl = buildGo124Module {
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
  name = "etcd-${version}";

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

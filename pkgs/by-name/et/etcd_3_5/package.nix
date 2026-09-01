{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
  symlinkJoin,
}:

let
  version = "3.5.33";
  etcdSrcHash = "sha256-XrFuYT1IOkwroRAHFOvgLQUcyBJ8LUrWse7xzG5GOWM=";
  etcdServerVendorHash = "sha256-j+nZL9yXnsPhBWZNOA2KI/L3bY1IajSI3KnjvZmHGhE=";
  etcdUtlVendorHash = "sha256-+0sduuTcLodiKdgJT8NzprC6XLwOo5ONwl/k8FwfEuU=";
  etcdCtlVendorHash = "sha256-OqMcTekZB5Otoio49wvV3zKNtE9ZA+7nd3D2vQOR6Fo=";

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

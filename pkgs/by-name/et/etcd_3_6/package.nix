{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  symlinkJoin,
  nixosTests,
  k3s,
}:

let
  # pinned buildGoModule to avoid checkphase errors, remove this when upgrading
  buildGoModule = buildGo123Module;

  version = "3.6.0-rc.4";
  etcdSrcHash = "sha256-OGfokFjgSC97Hb9wHifIDevLDrronh/VDaUR8r2hNXU=";
  etcdServerVendorHash = "sha256-TusJgTKn66D4LHr9Q9/V0jpJ3OR7g2t7T/JWQchWphk=";
  etcdUtlVendorHash = "sha256-0yKBVwkhfkAc5f3uE2F93nHRJks7YvPQJNTFkdpBGO4=";
  etcdCtlVendorHash = "sha256-lMsEadoK6u6gwj3Or/UaTjCy2eJHKjAhPLuA/LZwqLI=";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    hash = etcdSrcHash;
  };

  env = {
    CGO_ENABLED = 0;
  };

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.darwin ++ platforms.linux;
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

  etcdutl = buildGoModule rec {
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

  etcdctl = buildGoModule rec {
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
    inherit etcdserver etcdutl etcdctl;
    tests = {
      inherit (nixosTests) etcd etcd-cluster;
      k3s = k3s.passthru.tests.etcd;
    };
    updateScript = ./update.sh;
  };

  paths = [
    etcdserver
    etcdutl
    etcdctl
  ];
}

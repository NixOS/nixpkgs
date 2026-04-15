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
  version = "3.6.10";
  etcdSrcHash = "sha256-BGPOSML9Jd8D3eeksTykjM+lNvUxWw20jnXtxqg72Hc=";
  etcdCtlVendorHash = "sha256-uluiQqq6X7xswG5qh9odd8ylsVexTrwmKR3id8GEHj0=";
  etcdUtlVendorHash = "sha256-GVih32FEUV7FiDe/5+V5cDUhUM3D9kSA+5jpHu1fwFs=";
  etcdServerVendorHash = "sha256-silFeLWbqqSJ8WMmlE4dDH98cCFUKLQDvs8Vhx5LnDY=";

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
    maintainers = with lib.maintainers; [
      dtomvan
      superherointj
    ];
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
  pname = "etcd";

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

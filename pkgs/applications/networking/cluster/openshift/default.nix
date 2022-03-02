{ lib, fetchFromGitHub, buildGoPackage, which, go-bindata, rsync, util-linux
, coreutils, libkrb5, ncurses, clang, installShellFiles
, components ? [
  "cmd/oc"
  "cmd/openshift"
  ]
}:

with lib;

let
  version = "4.1.0";
  ver = lib.elemAt (lib.splitVersion version);
  versionMajor = ver 0;
  versionMinor = ver 1;
  versionPatch = ver 2;
  gitCommit = "b4261e0";
  # version is in vendor/k8s.io/kubernetes/pkg/version/base.go
  k8sversion = "v1.11.1";
  k8sgitcommit = "b1b2997";
  k8sgitMajor = "0";
  k8sgitMinor = "1";
in buildGoPackage rec {
  pname = "openshift-origin";
  inherit version;

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "origin";
    rev = "v${version}";
    sha256 = "16bc6ljm418kxz92gz8ldm82491mvlqamrvigyr6ff72rf7ml7ba";
  };

  goPackagePath = "github.com/openshift/origin";

  buildInputs = [ libkrb5 ];

  nativeBuildInputs = [
    clang
    go-bindata
    installShellFiles
    ncurses
    rsync
    which
  ];

  patchPhase = ''
    patchShebangs ./hack
  '';

  buildPhase = ''
    cd go/src/${goPackagePath}
    # Openshift build require this variables to be set
    # unless there is a .git folder which is not the case with fetchFromGitHub
    echo "OS_GIT_VERSION=v${version}" >> os-version-defs
    echo "OS_GIT_TREE_STATE=clean" >> os-version-defs
    echo "OS_GIT_MAJOR=${versionMajor}" >> os-version-defs
    echo "OS_GIT_MINOR=${versionMinor}" >> os-version-defs
    echo "OS_GIT_PATCH=${versionPatch}" >> os-version-defs
    echo "OS_GIT_COMMIT=${gitCommit}" >> os-version-defs
    echo "KUBE_GIT_VERSION=${k8sversion}" >> os-version-defs
    echo "KUBE_GIT_COMMIT=${k8sgitcommit}" >> os-version-defs
    echo "KUBE_GIT_MAJOR=${k8sgitMajor}" >> os-version-defs
    echo "KUBE_GIT_MINOR=${k8sgitMinor}" >> os-version-defs
    export OS_VERSION_FILE="os-version-defs"
    export CC=clang
    make all WHAT='${concatStringsSep " " components}'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a "_output/local/bin/$(go env GOOS)/$(go env GOARCH)/"* "$out/bin/"
    installShellCompletion --bash contrib/completions/bash/*
    installShellCompletion --zsh contrib/completions/zsh/*
  '';

  meta = with lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    license = licenses.asl20;
    homepage = "http://www.openshift.org";
    maintainers = with maintainers; [offline bachp moretea];
    platforms = platforms.unix;
  };
}

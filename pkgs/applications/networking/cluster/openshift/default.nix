{ stdenv, lib, fetchFromGitHub, buildGoPackage, which, go-bindata, rsync, utillinux
, coreutils, kerberos, clang
, components ? [
  "cmd/oc"
  "cmd/openshift"
  ]
}:

with lib;

let
  version = "3.11.0";
  ver = stdenv.lib.elemAt (stdenv.lib.splitString "." version);
  versionMajor = ver 0;
  versionMinor = ver 1;
  versionPatch = ver 2;
  gitCommit = "0cbc58b";
  # version is in vendor/k8s.io/kubernetes/pkg/version/base.go
  k8sversion = "v1.11.1";
  k8sgitcommit = "b1b2997";
  k8sgitMajor = "0";
  k8sgitMinor = "1";
in buildGoPackage rec {
  name = "openshift-origin-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "origin";
    rev = "v${version}";
    sha256 = "06q4v2a1mm6c659ab0rzkqz6b66vx4avqfg0s9xckwhq420lzgka";
  };

  goPackagePath = "github.com/openshift/origin";

  # go > 1.10
  # [FATAL] [14:44:02+0000] Please install Go version go or use PERMISSIVE_GO=y to bypass this check.
  buildInputs = [ which rsync go-bindata kerberos clang ];

  patchPhase = ''
    patchShebangs ./hack

    substituteInPlace pkg/oc/clusterup/docker/host/host.go  \
      --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt findmnt' \
      'nsenter --mount=/rootfs/proc/1/ns/mnt ${utillinux}/bin/findmnt'

    substituteInPlace pkg/oc/clusterup/docker/host/host.go  \
      --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt mount' \
      'nsenter --mount=/rootfs/proc/1/ns/mnt ${utillinux}/bin/mount'

    substituteInPlace pkg/oc/clusterup/docker/host/host.go  \
      --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt mkdir' \
      'nsenter --mount=/rootfs/proc/1/ns/mnt ${coreutils}/bin/mkdir'
  '';

  buildPhase = ''
    cd go/src/${goPackagePath}
    # Openshift build require this variables to be set
    # unless there is a .git folder which is not the case with fetchFromGitHub
    echo "OS_GIT_VERSION=v${version}" >> os-version-defs
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
    mkdir -p $bin/bin
    cp -a "_output/local/bin/$(go env GOOS)/$(go env GOARCH)/"* "$bin/bin/"
    install -D -t "$bin/etc/bash_completion.d" contrib/completions/bash/*
    install -D -t "$bin/share/zsh/site-functions" contrib/completions/zsh/*
  '';

  meta = with stdenv.lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    license = licenses.asl20;
    homepage = http://www.openshift.org;
    maintainers = with maintainers; [offline bachp moretea];
    platforms = platforms.unix;
  };
}

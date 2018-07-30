{ stdenv, lib, fetchFromGitHub, removeReferencesTo, which, go_1_9, go-bindata, makeWrapper, rsync, utillinux
, coreutils, kerberos, clang
, components ? [
  "cmd/oc"
  "cmd/openshift"
  ]
}:

with lib;

let
  version = "3.9.0";
  ver = stdenv.lib.elemAt (stdenv.lib.splitString "." version);
  versionMajor = ver 0;
  versionMinor = ver 1;
  versionPatch = ver 2;
  gitCommit = "191fece";
  # version is in vendor/k8s.io/kubernetes/pkg/version/base.go
  k8sversion = "v1.9.1";
  k8sgitcommit = "a0ce1bc657";
in stdenv.mkDerivation rec {
  name = "openshift-origin-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "origin";
    rev = "v${version}";
    sha256 = "06k0zilfyvll7z34yirraslgpwgah9k6y5i6wgi7f00a79k76k78";
};

  # go > 1.10
  # [FATAL] [14:44:02+0000] Please install Go version go1.9 or use PERMISSIVE_GO=y to bypass this check.
  buildInputs = [ removeReferencesTo makeWrapper which go_1_9 rsync go-bindata kerberos clang ];

  outputs = [ "out" ];

  patchPhase = ''
    patchShebangs ./hack

    substituteInPlace pkg/oc/bootstrap/docker/host/host.go  \
      --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt findmnt' \
      'nsenter --mount=/rootfs/proc/1/ns/mnt ${utillinux}/bin/findmnt'

    substituteInPlace pkg/oc/bootstrap/docker/host/host.go  \
      --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt mount' \
      'nsenter --mount=/rootfs/proc/1/ns/mnt ${utillinux}/bin/mount'

    substituteInPlace pkg/oc/bootstrap/docker/host/host.go  \
      --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt mkdir' \
      'nsenter --mount=/rootfs/proc/1/ns/mnt ${coreutils}/bin/mkdir'
  '';

  buildPhase = ''
    # Openshift build require this variables to be set
    # unless there is a .git folder which is not the case with fetchFromGitHub
    echo "OS_GIT_VERSION=v${version}" >> os-version-defs
    echo "OS_GIT_MAJOR=${versionMajor}" >> os-version-defs
    echo "OS_GIT_MINOR=${versionMinor}" >> os-version-defs
    echo "OS_GIT_PATCH=${versionPatch}" >> os-version-defs
    echo "OS_GIT_COMMIT=${gitCommit}" >> os-version-defs
    echo "KUBE_GIT_VERSION=${k8sversion}" >> os-version-defs
    echo "KUBE_GIT_COMMIT=${k8sgitcommit}" >> os-version-defs
    export OS_VERSION_FILE="os-version-defs"
    export CC=clang
    make all WHAT='${concatStringsSep " " components}'
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp -a "_output/local/bin/$(go env GOOS)/$(go env GOARCH)/"* "$out/bin/"
    install -D -t "$out/etc/bash_completion.d" contrib/completions/bash/*
    install -D -t "$out/share/zsh/site-functions" contrib/completions/zsh/*
  '';

  preFixup = ''
    find $out/bin -type f -exec remove-references-to -t ${go_1_9} '{}' +
  '';

  meta = with stdenv.lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    license = licenses.asl20;
    homepage = http://www.openshift.org;
    maintainers = with maintainers; [offline bachp moretea];
    platforms = platforms.linux;
  };
}

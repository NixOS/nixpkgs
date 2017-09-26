{ stdenv, fetchFromGitHub, which, buildGoPackage, utillinux, coreutils }:

let
  version = "3.6.0";
  ver = stdenv.lib.elemAt (stdenv.lib.splitString "." version);
  versionMajor = ver 0;
  versionMinor = ver 1;
  versionPatch = ver 2;
in buildGoPackage rec {
  name = "openshift-origin-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "origin";
    rev = "v${version}";
    sha256 = "08bdqvsjl6c7dmllyz8n4akb7gyn91znvbph5cgmmk1bhskycy1r";
  };

  buildInputs = [ which ];

  goPackagePath = null;
  patchPhase = ''
    patchShebangs ./hack
    substituteInPlace pkg/bootstrap/docker/host/host.go  \
      --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt findmnt' \
      'nsenter --mount=/rootfs/proc/1/ns/mnt ${utillinux}/bin/findmnt'

    substituteInPlace pkg/bootstrap/docker/host/host.go  \
      --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt mount' \
      'nsenter --mount=/rootfs/proc/1/ns/mnt ${utillinux}/bin/mount'

    substituteInPlace pkg/bootstrap/docker/host/host.go  \
      --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt mkdir' \
      'nsenter --mount=/rootfs/proc/1/ns/mnt ${utillinux}/bin/mount'
  '';

  buildPhase = ''
    cd go/src/origin-v${version}-src
    # Openshift build require this variables to be set
    # unless there is a .git folder which is not the case with fetchFromGitHub
    export OS_GIT_VERSION=v${version}
    export OS_GIT_MAJOR=${versionMajor}
    export OS_GIT_MINOR=${versionMinor}
    make build
  '';

  installPhase = ''
    mkdir -p "$bin/bin"
    cp -a "_output/local/bin/$(go env GOOS)/$(go env GOARCH)/"* "$bin/bin/"
  '';

  meta = with stdenv.lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    license = licenses.asl20;
    homepage = http://www.openshift.org;
    maintainers = with maintainers; [offline bachp moretea];
    platforms = platforms.linux;
  };
}

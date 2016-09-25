{ stdenv, lib, fetchFromGitHub, makeWrapper, pkgconfig, go-md2man
, go, containerd, runc
, sqlite, iproute, bridge-utils, devicemapper, systemd
, btrfs-progs, iptables, e2fsprogs, xz, utillinux, xfsprogs
, procps
}:

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md

with lib;

stdenv.mkDerivation rec {
  name = "docker-${version}";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "docker";
    rev = "v${version}";
    sha256 = "079786dyydjfc8vb6djxh140pc7v16fjl5x2h2q420qc3mrfz5zd";
  };

  buildInputs = [
    makeWrapper pkgconfig go-md2man go
    sqlite devicemapper btrfs-progs systemd
  ];

  dontStrip = true;

  DOCKER_BUILDTAGS = []
    ++ optional (systemd != null) [ "journald" ]
    ++ optional (btrfs-progs == null) "exclude_graphdriver_btrfs"
    ++ optional (devicemapper == null) "exclude_graphdriver_devicemapper";

  # systemd 230 no longer has libsystemd-journal as a separate entity from libsystemd
  postPatch = ''
    substituteInPlace ./hack/make.sh                   --replace libsystemd-journal libsystemd
    substituteInPlace ./daemon/logger/journald/read.go --replace libsystemd-journal libsystemd
  '';

  buildPhase = ''
    patchShebangs .
    export AUTO_GOPATH=1
    export DOCKER_GITCOMMIT="23cf638"
    ./hack/make.sh dynbinary
  '';

  outputs = ["out" "man"];

  extraPath = makeBinPath [ iproute iptables e2fsprogs xz xfsprogs procps utillinux ];

  installPhase = ''
    install -Dm755 ./bundles/${version}/dynbinary-client/docker-${version} $out/libexec/docker/docker
    install -Dm755 ./bundles/${version}/dynbinary-daemon/dockerd-${version} $out/libexec/docker/dockerd
    install -Dm755 ./bundles/${version}/dynbinary-daemon/docker-proxy-${version} $out/libexec/docker/docker-proxy
    makeWrapper $out/libexec/docker/docker $out/bin/docker \
      --prefix PATH : "$out/libexec/docker:$extraPath"
    makeWrapper $out/libexec/docker/dockerd $out/bin/dockerd \
      --prefix PATH : "$out/libexec/docker:$extraPath"

    # docker uses containerd now
    ln -s ${containerd}/bin/containerd $out/libexec/docker/docker-containerd
    ln -s ${containerd}/bin/containerd-shim $out/libexec/docker/docker-containerd-shim
    ln -s ${runc}/bin/runc $out/libexec/docker/docker-runc

    # systemd
    install -Dm644 ./contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service

    # completion
    install -Dm644 ./contrib/completion/bash/docker $out/share/bash-completion/completions/docker
    install -Dm644 ./contrib/completion/fish/docker.fish $out/share/fish/vendor_completions.d/docker.fish
    install -Dm644 ./contrib/completion/zsh/_docker $out/share/zsh/site-functions/_docker

    # Include contributed man pages
    man/md2man-all.sh -q
    manRoot="$man/share/man"
    mkdir -p "$manRoot"
    for manDir in man/man?; do
      manBase="$(basename "$manDir")" # "man1"
      for manFile in "$manDir"/*; do
        manName="$(basename "$manFile")" # "docker-build.1"
        mkdir -p "$manRoot/$manBase"
        gzip -c "$manFile" > "$manRoot/$manBase/$manName.gz"
      done
    done
  '';

  preFixup = ''
    # remove references to go compiler, gcc and glibc
    while read file; do
      sed -ri "s,${go},$(echo "${go}" | sed "s,$NIX_STORE/[^-]*,$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee,"),g" $file
      sed -ri "s,${stdenv.cc.cc},$(echo "${stdenv.cc.cc}" | sed "s,$NIX_STORE/[^-]*,$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee,"),g" $file
      sed -ri "s,${stdenv.glibc.dev},$(echo "${stdenv.glibc.dev}" | sed "s,$NIX_STORE/[^-]*,$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee,"),g" $file
    done < <(find $out -type f 2>/dev/null)
  '';

  meta = {
    homepage = http://www.docker.com/;
    description = "An open source project to pack, ship and run any application as a lightweight container";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline tailhook ];
    platforms = platforms.linux;
  };
}

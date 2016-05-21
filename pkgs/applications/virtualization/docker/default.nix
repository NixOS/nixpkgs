{ stdenv, fetchFromGitHub, makeWrapper
, go, sqlite, iproute, bridge-utils, devicemapper
, btrfs-progs, iptables, e2fsprogs, xz, utillinux
, xfsprogs, containerd, runc
, systemd, pkgconfig, md2man
}:

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "docker-${version}";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "docker";
    rev = "v${version}";
    sha256 = "0anpxhgxz64fd2062a0s63qhp1h5bgydghc91xqyib271da2szi8";
  };

  buildInputs = [
    makeWrapper go sqlite iproute bridge-utils devicemapper btrfs-progs
    iptables e2fsprogs systemd pkgconfig md2man
  ];

  dontStrip = true;

  DOCKER_BUILDTAGS = [ "journald" ]
    ++ optional (btrfs-progs == null) "exclude_graphdriver_btrfs"
    ++ optional (devicemapper == null) "exclude_graphdriver_devicemapper";

  buildPhase = ''
    patchShebangs .
    export AUTO_GOPATH=1
    export DOCKER_GITCOMMIT="5604cbed"
    ./hack/make.sh dynbinary
  '';

  outputs = ["out" "man"];

  installPhase = ''
    install -Dm755 ./bundles/${version}/dynbinary/docker-${version} $out/libexec/docker/docker
    makeWrapper $out/libexec/docker/docker $out/bin/docker \
      --prefix PATH : "${iproute}/sbin:sbin:${iptables}/sbin:${e2fsprogs}/sbin:${xz.bin}/bin:${xfsprogs}/bin:${utillinux}/bin:$out/libexec/docker/"

    # docker uses containerd now
    ln -s ${containerd}/bin/containerd $out/libexec/docker/docker-containerd
    ln -s ${containerd}/bin/containerd-shim $out/libexec/docker/docker-containerd-shim
    ln -s ${runc}/bin/runc $out/libexec/docker/docker-runc

    # systemd
    install -Dm644 ./contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service

    # completion
    install -Dm644 ./contrib/completion/bash/docker $out/share/bash-completion/completions/docker
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

  meta = with stdenv.lib; {
    homepage = http://www.docker.com/;
    description = "An open source project to pack, ship and run any application as a lightweight container";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline tailhook ];
    platforms = platforms.linux;
  };
}

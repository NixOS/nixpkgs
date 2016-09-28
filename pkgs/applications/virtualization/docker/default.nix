{ stdenv, fetchFromGitHub, makeWrapper
, go, sqlite, iproute, bridge-utils, devicemapper
, btrfs-progs, iptables, e2fsprogs, xz, utillinux
, systemd, pkgconfig
}:

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "docker-${version}";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "docker";
    rev = "v${version}";
    sha256 = "0bmrafi0p3fm681y165ps97jki0a8ihl9f0bmpvi22nmc1v0sv6l";
  };

  buildInputs = [
    makeWrapper go sqlite iproute bridge-utils devicemapper btrfs-progs
    iptables e2fsprogs systemd pkgconfig stdenv.glibc stdenv.glibc.static
  ];

  dontStrip = true;

  DOCKER_BUILDTAGS = [ "journald" ]
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
    export DOCKER_GITCOMMIT="20f81dde"
    ./hack/make.sh dynbinary
  '';

  installPhase = ''
    install -Dm755 ./bundles/${version}/dynbinary/docker-${version} $out/libexec/docker/docker
    install -Dm755 ./bundles/${version}/dynbinary/dockerinit-${version} $out/libexec/docker/dockerinit
    makeWrapper $out/libexec/docker/docker $out/bin/docker \
      --prefix PATH : "${stdenv.lib.makeBinPath [ iproute iptables e2fsprogs xz utillinux ]}"

    # systemd
    install -Dm644 ./contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service

    # completion
    install -Dm644 ./contrib/completion/bash/docker $out/share/bash-completion/completions/docker
    install -Dm644 ./contrib/completion/fish/docker.fish $out/share/fish/vendor_completions.d/docker.fish
    install -Dm644 ./contrib/completion/zsh/_docker $out/share/zsh/site-functions/_docker
  '';

  meta = with stdenv.lib; {
    homepage = http://www.docker.com/;
    description = "An open source project to pack, ship and run any application as a lightweight container";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline tailhook ];
    platforms = platforms.linux;
  };
}

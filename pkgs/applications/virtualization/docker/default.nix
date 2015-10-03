{ stdenv, fetchFromGitHub, makeWrapper, go, lxc, sqlite, iproute, bridge-utils, devicemapper,
btrfsProgs, iptables, bash, e2fsprogs, xz, utillinux}:

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md

stdenv.mkDerivation rec {
  name = "docker-${version}";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "docker";
    rev = "v${version}";
    sha256 = "0nwd5wsw9f50jh4s5c5sfd6hnyh3g2kmxcrid36y1phabh30yrcz";
  };

  buildInputs = [ makeWrapper go sqlite lxc iproute bridge-utils devicemapper btrfsProgs iptables e2fsprogs ];

  dontStrip = true;

  preConfigure = ''
    mv vendor/src/github.com/opencontainers/runc/libcontainer/seccomp/{jump_amd64.go,jump_linux.go}
    sed -i 's/,amd64//' vendor/src/github.com/opencontainers/runc/libcontainer/seccomp/jump_linux.go
  '';

  buildPhase = ''
    patchShebangs .
    export AUTO_GOPATH=1
    export DOCKER_GITCOMMIT="786b29d4"
    ./hack/make.sh dynbinary
  '';

  installPhase = ''
    install -Dm755 ./bundles/${version}/dynbinary/docker-${version} $out/libexec/docker/docker
    install -Dm755 ./bundles/${version}/dynbinary/dockerinit-${version} $out/libexec/docker/dockerinit
    makeWrapper $out/libexec/docker/docker $out/bin/docker --prefix PATH : "${iproute}/sbin:sbin:${lxc}/bin:${iptables}/sbin:${e2fsprogs}/sbin:${xz}/bin:${utillinux}/bin"

    # systemd
    install -Dm644 ./contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service

    # completion
    install -Dm644 ./contrib/completion/bash/docker $out/share/bash-completion/completions/docker
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

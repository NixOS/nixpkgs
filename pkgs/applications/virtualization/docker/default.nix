{ stdenv, fetchurl, makeWrapper, go, lxc, sqlite, iproute, bridge-utils, devicemapper,
btrfsProgs, iptables, bash, e2fsprogs, xz}:

stdenv.mkDerivation rec {
  name = "docker-${version}";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/dotcloud/docker/archive/v${version}.tar.gz";
    sha256 = "03nzhikxp60falshzyk6ip8g9fhrczhvnvgmzqr8bny6w8x1v84b";
  };

  buildInputs = [ makeWrapper go sqlite lxc iproute bridge-utils devicemapper btrfsProgs iptables e2fsprogs ];

  dontStrip = true;

  buildPhase = ''
    patchShebangs ./project
    export AUTO_GOPATH=1
    export DOCKER_GITCOMMIT="03nzhikx"
    ./hack/make.sh dynbinary
  '';

  installPhase = ''
    install -Dm755 ./bundles/${version}/dynbinary/docker-${version} $out/libexec/docker/docker
    install -Dm755 ./bundles/${version}/dynbinary/dockerinit-${version} $out/libexec/docker/dockerinit
    makeWrapper $out/libexec/docker/docker $out/bin/docker --prefix PATH : "${iproute}/sbin:sbin:${lxc}/bin:${iptables}/sbin:${e2fsprogs}/sbin:${xz}/bin"

    # systemd
    install -Dm644 ./contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service

    # completion
    install -Dm644 ./contrib/completion/bash/docker $out/share/bash-completion/completions/docker
    install -Dm644 ./contrib/completion/zsh/_docker $out/share/zsh/site-functions/_docker
  '';

  meta = with stdenv.lib; {
    homepage = http://www.docker.io/;
    description = "An open source project to pack, ship and run any application as a lightweight container";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline tailhook ];
    platforms = platforms.linux;
  };
}

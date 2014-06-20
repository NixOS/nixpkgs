{ stdenv, fetchurl, makeWrapper, go, lxc, sqlite, iproute, bridge_utils, devicemapper,
btrfsProgs, iptables, bash, apparmor}:

stdenv.mkDerivation rec {
  name = "docker-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/dotcloud/docker/archive/v${version}.tar.gz";
    sha256 = "1iz4kbi1pdkzb7hq7vfylpfrbvll06w2mrl3b35h26h3zx7hxa7g";
  };

  phases = ["unpackPhase" "preBuild" "buildPhase" "installPhase"];

  buildInputs = [ makeWrapper go sqlite lxc iproute bridge_utils devicemapper btrfsProgs iptables ];

  preBuild = ''
    patchShebangs ./hack
  '';

  buildPhase = ''
    export AUTO_GOPATH=1
    export DOCKER_GITCOMMIT="990021ac2b4a4c8e6ae66dd331c372f70eec3b7a"
    ./hack/make.sh dynbinary
  '';

  installPhase = ''
    install -Dm755 ./bundles/${version}/dynbinary/docker-${version} $out/bin/docker
    install -Dm755 ./bundles/${version}/dynbinary/dockerinit-${version} $out/bin/dockerinit
    wrapProgram $out/bin/docker --prefix PATH : "${iproute}/sbin:sbin:${lxc}/bin:${iptables}/sbin"

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
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}

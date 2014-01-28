{ stdenv, fetchurl, makeWrapper, go, lxc, sqlite, iproute, iptables, lvm2
, bash}:

stdenv.mkDerivation rec {
  name = "docker-${version}";
  version = "0.7.6";

  src = fetchurl {
    url = "https://github.com/dotcloud/docker/archive/v${version}.tar.gz";
    sha256 = "0anlzba2vm1fs5nf0dl2svrgj3ddsbl5iyhsm8vfbi3f23vppkfv";
  };

  phases = ["unpackPhase" "preBuild" "buildPhase" "installPhase"];

  buildInputs = [ makeWrapper go sqlite lxc iproute lvm2 iptables ];

  preBuild = ''
    patchShebangs ./hack
  '';

  buildPhase = ''
    mkdir -p src/github.com/dotcloud
    ln -sn "../../../" "src/github.com/dotcloud/docker"
    export GOPATH="$(pwd):$(pwd)/vendor"
    export DOCKER_GITCOMMIT="bc3b2ec0622f50879ae96f042056b6bd2e0b4fba"
    export DOCKER_INITPATH="$out/libexec/docker/dockerinit"
    ./hack/make.sh dynbinary
  '';

  installPhase = ''
    install -Dm755 ./bundles/${version}/dynbinary/docker-${version} $out/bin/docker
    install -Dm755 ./bundles/${version}/dynbinary/dockerinit-${version} $out/libexec/docker/dockerinit
    wrapProgram $out/bin/docker --prefix PATH : "${iproute}/sbin:${lvm2}:sbin:${lxc}/bin:${iptables}/sbin"

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

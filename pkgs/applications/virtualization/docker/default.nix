{ stdenv, fetchFromGitHub, makeWrapper
, go, sqlite, iproute, bridge-utils, devicemapper
, btrfs-progs, iptables, e2fsprogs, xz, utillinux
, enableLxc ? false, lxc
}:

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "docker-${version}";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "docker";
    rev = "v${version}";
    sha256 = "1mhi4y820h2wxz6hqmr95c7yvklyw578dd9c83jr463w7rq0rgr6";
  };

  buildInputs = [
    makeWrapper go sqlite iproute bridge-utils devicemapper btrfs-progs
    iptables e2fsprogs
  ];

  dontStrip = true;

  buildPhase = ''
    patchShebangs .
    export AUTO_GOPATH=1
    export DOCKER_GITCOMMIT="a34a1d59"
    ./hack/make.sh dynbinary
  '';

  installPhase = ''
    install -Dm755 ./bundles/${version}/dynbinary/docker-${version} $out/libexec/docker/docker
    install -Dm755 ./bundles/${version}/dynbinary/dockerinit-${version} $out/libexec/docker/dockerinit
    makeWrapper $out/libexec/docker/docker $out/bin/docker \
      --prefix PATH : "${iproute}/sbin:sbin:${iptables}/sbin:${e2fsprogs}/sbin:${xz}/bin:${utillinux}/bin:${optionalString enableLxc "${lxc}/bin"}"

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

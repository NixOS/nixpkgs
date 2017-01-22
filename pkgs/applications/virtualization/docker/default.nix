{ stdenv, lib, fetchFromGitHub, makeWrapper, pkgconfig, go-md2man
, go, containerd, runc, docker-proxy, tini
, sqlite, iproute, bridge-utils, devicemapper, systemd
, btrfs-progs, iptables, e2fsprogs, xz, utillinux, xfsprogs
, procps
}:

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md

with lib;

stdenv.mkDerivation rec {
  name = "docker-${version}";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "docker";
    rev = "v${version}";
    sha256 = "03b181xiqgnwanc567w9p6rbdgdvrfv0lk4r7b604ksm0fr4cz23";
  };

  docker-runc = runc.overrideAttrs (oldAttrs: rec {
    name = "docker-runc";
    src = fetchFromGitHub {
      owner = "docker";
      repo = "runc";
      rev = "2f7393a47307a16f8cee44a37b262e8b81021e3e";
      sha256 = "1s5nfnbinzmcnm8avhvsniz0ihxyva4w5qz1hzzyqdyr0w2scnbj";
    };
    # docker/runc already include these patches / are not applicable
    patches = [];
  });
  docker-containerd = containerd.overrideAttrs (oldAttrs: rec {
    name = "docker-containerd";
    src = fetchFromGitHub {
      owner = "docker";
      repo = "containerd";
      rev = "03e5862ec0d8d3b3f750e19fca3ee367e13c090e";
      sha256 = "184sd9dwkcba3zhxnz9grw8p81x05977p36cif2dgkhjdhv12map";
    };
  });
  docker-tini = tini.overrideAttrs  (oldAttrs: rec {
    name = "docker-init";
    src = fetchFromGitHub {
      owner = "krallin";
      repo = "tini";
      rev = "949e6facb77383876aeff8a6944dde66b3089574";
      sha256 = "0zj4kdis1vvc6dwn4gplqna0bs7v6d1y2zc8v80s3zi018inhznw";
    };

    # Do not remove static from make files as we want a static binary
    patchPhase = ''
    '';

    NIX_CFLAGS_COMPILE = [
      "-DMINIMAL=ON"
    ];
  });

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
    makeWrapper $out/libexec/docker/docker $out/bin/docker \
      --prefix PATH : "$out/libexec/docker:$extraPath"
    makeWrapper $out/libexec/docker/dockerd $out/bin/dockerd \
      --prefix PATH : "$out/libexec/docker:$extraPath"

    # docker uses containerd now
    ln -s ${docker-containerd}/bin/containerd $out/libexec/docker/docker-containerd
    ln -s ${docker-containerd}/bin/containerd-shim $out/libexec/docker/docker-containerd-shim
    ln -s ${docker-runc}/bin/runc $out/libexec/docker/docker-runc
    ln -s ${docker-proxy}/bin/docker-proxy $out/libexec/docker/docker-proxy
    ln -s ${docker-tini}/bin/tini-static $out/libexec/docker/docker-init

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

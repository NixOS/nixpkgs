{ stdenv, lib, fetchFromGitHub, makeWrapper, removeReferencesTo, pkgconfig
, go-md2man, go, containerd, runc, docker-proxy, tini
, sqlite, iproute, bridge-utils, devicemapper, systemd
, btrfs-progs, iptables, e2fsprogs, xz, utillinux, xfsprogs
, procps
}:

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md
# https://github.com/docker/docker/blob/TAG/hack/dockerfile/binaries-commits

with lib;

rec {
  dockerGen = {
      version, rev, sha256
      , runcRev, runcSha256
      , containerdRev, containerdSha256
      , tiniRev, tiniSha256
  } : stdenv.mkDerivation rec {
    inherit version rev;

    name = "docker-${version}";

    src = fetchFromGitHub {
      owner = "docker";
      repo = "docker";
      rev = "v${version}";
      sha256 = sha256;
    };

    docker-runc = runc.overrideAttrs (oldAttrs: rec {
      name = "docker-runc";
      src = fetchFromGitHub {
        owner = "docker";
        repo = "runc";
        rev = runcRev;
        sha256 = runcSha256;
      };
      # docker/runc already include these patches / are not applicable
      patches = [];
    });
    docker-containerd = containerd.overrideAttrs (oldAttrs: rec {
      name = "docker-containerd";
      src = fetchFromGitHub {
        owner = "docker";
        repo = "containerd";
        rev = containerdRev;
        sha256 = containerdSha256;
      };
    });
    docker-tini = tini.overrideAttrs  (oldAttrs: rec {
      name = "docker-init";
      src = fetchFromGitHub {
        owner = "krallin";
        repo = "tini";
        rev = tiniRev;
        sha256 = tiniSha256;
      };

      # Do not remove static from make files as we want a static binary
      patchPhase = ''
      '';

      NIX_CFLAGS_COMPILE = [
        "-DMINIMAL=ON"
      ];
    });

    buildInputs = [
      makeWrapper removeReferencesTo pkgconfig go-md2man go
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
      export DOCKER_GITCOMMIT="${rev}"
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
      find $out -type f -exec remove-references-to -t ${go} -t ${stdenv.cc.cc} -t ${stdenv.glibc.dev} '{}' +
    '';

    meta = {
      homepage = http://www.docker.com/;
      description = "An open source project to pack, ship and run any application as a lightweight container";
      license = licenses.asl20;
      maintainers = with maintainers; [ offline tailhook ];
      platforms = platforms.linux;
    };
  };

  docker_17_03 = dockerGen rec {
    version = "17.03.1-ce";
    rev = "c6d412e"; # git commit
    sha256 = "1h3hkg15c3isfgaqpkp3mr7ys5826cz24hn3f3wz07jmismq98q7";
    runcRev = "54296cf40ad8143b62dbcaa1d90e520a2136ddfe";
    runcSha256 = "0ylymx7pi4jmvbqj94j2i8qspy8cpq0m91l6a0xiqlx43yx6qi2m";
    containerdRev = "4ab9917febca54791c5f071a9d1f404867857fcc";
    containerdSha256 = "06f2gsx4w9z4wwjhrpafmz6c829wi8p7crj6sya6x9ii50bkn8p6";
    tiniRev = "949e6facb77383876aeff8a6944dde66b3089574";
    tiniSha256 = "0zj4kdis1vvc6dwn4gplqna0bs7v6d1y2zc8v80s3zi018inhznw";
  };

  docker_17_05 = dockerGen rec {
    version = "17.05.0-ce";
    rev = "90d35abf7b3535c1c319c872900fbd76374e521c"; # git commit
    sha256 = "1m4fcawjj14qws57813wjxjwgnrfxgxnnzlj61csklp0s9dhg7df";
    runcRev = "9c2d8d184e5da67c95d601382adf14862e4f2228";
    runcSha256 = "131jv8f77pbdlx88ar0zjwdsp0a5v8kydaw0w0cl3i0j3622ydjl";
    containerdRev = "9048e5e50717ea4497b757314bad98ea3763c145";
    containerdSha256 = "1r9xhvzzh7md08nqb0rbp5d1rdr7jylb3da954d0267i0kh2iksa";
    tiniRev = "949e6facb77383876aeff8a6944dde66b3089574";
    tiniSha256 = "0zj4kdis1vvc6dwn4gplqna0bs7v6d1y2zc8v80s3zi018inhznw";
  };
}

{ stdenv
, lib
, makeWrapper
, socat
, iptables
, iproute
, bridge-utils
, conntrack-tools
, buildGoPackage
, git
, runc
, libseccomp
, pkgconfig
, ethtool
, utillinux
, ipset
, fetchFromGitHub
, fetchurl
, fetchzip
, fetchgit
}:

with lib;

# k3s is a kinda weird derivation. One of the main points of k3s is the
# simplicity of it being one binary that can perform several tasks.
# However, when you have a good package manager (like nix), that doesn't
# actually make much of a difference; you don't really care if it's one binary
# or 10 since with a good package manager, installing and running it is
# identical.
# Since upstream k3s packages itself as one large binary with several
# "personalities" (in the form of subcommands like 'k3s agent' and 'k3s
# kubectl'), it ends up being easiest to mostly mimic upstream packaging, with
# some exceptions.
# K3s also carries patches to some packages (such as containerd and cni
# plugins), so we intentionally use the k3s versions of those binaries for k3s,
# even if the upstream version of those binaries exist in nixpkgs already. In
# the end, that means we have a thick k3s binary that behaves like the upstream
# one for the most part.
# However, k3s also bundles several pieces of unpatched software, from the
# strongswan vpn software, to iptables, to socat, conntrack, busybox, etc.
# Those pieces of software we entirely ignore upstream's handling of, and just
# make sure they're in the path if desired.
let
  k3sVersion = "1.18.8+k3s1";     # k3s git tag
  traefikChartVersion = "1.81.0"; # taken from ./scripts/download at the above k3s tag
  k3sRootVersion = "0.4.1";       # taken from ./scripts/download at the above k3s tag
  k3sCNIVersion = "0.8.6-k3s1";   # taken from ./scripts/version.sh at the above k3s tag
  # bundled into the k3s binary
  traefikChart = fetchurl {
    url = "https://kubernetes-charts.storage.googleapis.com/traefik-${traefikChartVersion}.tgz";
    sha256 = "1aqpzgjlvqhil0g3angz94zd4xbl4iq0qmpjcy5aq1xv9qciwdi9";
  };
  # so, k3s is a complicated thing to package
  # This derivation attempts to avoid including any random binaries from the
  # internet. k3s-root is _mostly_ binaries built to be bundled in k3s (which
  # we don't care about doing, we can add those as build or runtime
  # dependencies using a real package manager).
  # In addition to those binaries, it's also configuration though (right now
  # mostly strongswan configuration), and k3s does use those files.
  # As such, we download it in order to grab 'etc' and bundle it into the final
  # k3s binary.
  k3sRoot = fetchzip {
    # Note: marked as apache 2.0 license
    url = "https://github.com/rancher/k3s-root/releases/download/v${k3sRootVersion}/k3s-root-amd64.tar";
    sha256 = "0ppj8y9g410hn6mjkfgfsi2j9yv7rcpic21znpmbrkx8b2070hf0";
    stripRoot = false;
  };
  k3sPlugins = buildGoPackage rec {
    name = "k3s-cni-plugins";
    version = k3sCNIVersion;

    goPackagePath = "github.com/containernetworking/plugins";
    subPackages = [ "." ];

    src = fetchFromGitHub {
      owner = "rancher";
      repo = "plugins";
      rev = "v${version}";
      sha256 = "13kx9msn5y9rw8v1p717wx0wbjqln59g6y3qfb1760aiwknva35q";
    };

    meta = {
      description = "CNI plugins, as patched by rancher for k3s";
      license = licenses.asl20;
      homepage = "https://k3s.io";
      maintainers = [ maintainers.euank ];
      platforms = platforms.linux;
    };
  };
  # Grab this separately from a build because it's used by both stages of the
  # k3s build.
  k3sRepo = fetchgit {
    url = "https://github.com/rancher/k3s";
    rev = "v${k3sVersion}";
    leaveDotGit = true; # ./scripts/version.sh depends on git
    sha256 = "17qsvbj1lvgxqdkxayyqnjwsjs3cx06nfv2hqvixjszn4vf30qlg";
  };
  # Stage 1 of the k3s build:
  # Let's talk about how k3s is structured.
  # One of the ideas of k3s is that there's the single "k3s" binary which can
  # do everything you need, from running a k3s server, to being a worker node,
  # to running kubectl.
  # The way that actually works is that k3s is a single go binary that contains
  # a bunch of bindata that it unpacks at runtime into directories (either the
  # user's home directory or /var/lib/rancher if run as root).
  # This bindata includes both binaries and configuration.
  # In order to let nixpkgs do all its autostripping/patching/etc, we split this into two derivations.
  # First, we build all the binaries that get packed into the thick k3s binary
  # (and output them from one derivation so they'll all be suitably patched up).
  # Then, we bundle those binaries into our thick k3s binary and use that as
  # the final single output.
  # This approach was chosen because it ensures the bundled binaries all are
  # correctly built to run with nix (we can lean on the existing buildGoPackage
  # stuff), and we can again lean on that tooling for the final k3s binary too.
  # Other alternatives would be to manually run the
  # strip/patchelf/remove-references step ourselves in the installPhase of the
  # derivation when we've built all the binaries, but haven't bundled them in
  # with generated bindata yet.
  k3sBuildStage1 = buildGoPackage rec {
    name = "k3s-build-1";
    version = "${k3sVersion}";

    goPackagePath = "github.com/rancher/k3s";

    src = k3sRepo;

    patches = [ ./patches/0001-Use-rm-from-path-in-go-generate.patch ./patches/0002-Add-nixpkgs-patches.patch ];

    nativeBuildInputs = [ git pkgconfig ];
    buildInputs = [ libseccomp ];

    buildPhase = ''
      pushd go/src/${goPackagePath}

      patchShebangs ./scripts/build ./scripts/version.sh
      mkdir -p bin
      ./scripts/build

      popd
    '';

    installPhase = ''
      pushd go/src/${goPackagePath}

      mkdir -p "$out/bin"
      install -m 0755 -t "$out/bin" ./bin/*

      popd
    '';

    meta = {
      description = "The various binaries that get packaged into the final k3s binary.";
      license = licenses.asl20;
      homepage = "https://k3s.io";
      maintainers = [ maintainers.euank ];
      platforms = platforms.linux;
    };
  };
  k3sBuild = buildGoPackage rec {
    name = "k3s-build";
    version = "${k3sVersion}";

    goPackagePath = "github.com/rancher/k3s";

    src = k3sRepo;

    patches = [ ./patches/0001-Use-rm-from-path-in-go-generate.patch ./patches/0002-Add-nixpkgs-patches.patch ];

    nativeBuildInputs = [ git pkgconfig ];
    buildInputs = [ k3sBuildStage1 k3sPlugins runc ];

    # k3s appends a suffix to the final distribution binary for some arches
    archSuffix =
      if stdenv.hostPlatform.system == "x86_64-linux" then ""
      else if stdenv.hostPlatform.system == "aarch64-linux" then "-arm64"
      else throw "k3s isn't being built for ${stdenv.hostPlatform.system} yet.";

    # In order to build the thick k3s binary (which is what
    # ./scripts/package-cli does), we need to get all the binaries that script
    # expects in place.
    buildPhase = ''
      pushd go/src/${goPackagePath}

      patchShebangs ./scripts/build ./scripts/version.sh ./scripts/package-cli

      mkdir -p bin

      install -m 0755 -t ./bin ${k3sBuildStage1}/bin/*
      install -m 0755 -T "${k3sPlugins}/bin/plugins" ./bin/cni
      # Note: use the already-nixpkgs-bundled k3s rather than the one bundled
      # in k3s because the k3s one is completely unmodified from upstream
      # (unlike containerd, cni, etc)
      install -m 0755 -T "${runc}/bin/runc" ./bin/runc
      cp -R "${k3sRoot}/etc" ./etc
      mkdir -p "build/static/charts"
      cp "${traefikChart}" "build/static/charts/traefik-${traefikChartVersion}.tgz"

      ./scripts/package-cli

      popd
    '';

    installPhase = ''
      pushd go/src/${goPackagePath}

      mkdir -p "$out/bin"
      install -m 0755 -T ./dist/artifacts/k3s${archSuffix} "$out/bin/k3s"

      popd
    '';

    meta = {
      description = "The k3s go binary which is used by the final wrapped output below.";
      license = licenses.asl20;
      homepage = "https://k3s.io";
      maintainers = [ maintainers.euank ];
      platforms = platforms.linux;
    };
  };
in
stdenv.mkDerivation rec {
  name = "k3s";

  # Important utilities used by  the kubelet, see
  # https://github.com/kubernetes/kubernetes/issues/26093#issuecomment-237202494
  # Note the list in that issue is stale and some aren't relevant for k3s.
  k3sRuntimeDeps = [
    socat
    iptables
    iproute
    bridge-utils
    ethtool
    utillinux
    ipset
    conntrack-tools
  ];

  buildInputs = [
    k3sBuild
    makeWrapper
  ] ++ k3sRuntimeDeps;

  unpackPhase = "true";

  # And, one final derivation (you thought the last one was it, right?)
  # We got the binary we wanted above, but it doesn't have all the runtime
  # dependencies k8s wants, including mount utilities for kubelet, networking
  # tools for cni/kubelet stuff, etc
  # Use a wrapper script to reference all the binaries that k3s tries to
  # execute, but that we didn't bundle with it.
  installPhase = ''
    mkdir -p "$out/bin"
    makeWrapper ${k3sBuild}/bin/k3s "$out/bin/k3s" \
      --prefix PATH : ${lib.makeBinPath k3sRuntimeDeps} \
      --prefix PATH : "$out/bin"
  '';

  meta = {
    description = "A lightweight Kubernetes distribution.";
    license = licenses.asl20;
    homepage = "https://k3s.io";
    maintainers = [ maintainers.euank ];
    platforms = platforms.linux;
  };
}

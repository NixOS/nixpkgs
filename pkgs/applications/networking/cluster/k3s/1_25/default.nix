{ stdenv
, lib
, makeWrapper
, socat
, iptables
, iproute2
, bridge-utils
, btrfs-progs
, conntrack-tools
, buildGoModule
, runc
, rsync
, kmod
, libseccomp
, pkg-config
, ethtool
, util-linux
, fetchFromGitHub
, fetchurl
, fetchzip
, fetchgit
, zstd
, yq-go
, nixosTests
, pkgsBuildBuild
, k3s
}:

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
  k3sVersion = "1.25.3+k3s1";     # k3s git tag
  k3sCommit = "f2585c1671b31b4b34bddbb3bf4e7d69662b0821"; # k3s git commit at the above version
  k3sRepoSha256 = "0zwf3iwjcidx14zw36s1hr0q8wmmbfc0rfqwd7fmpjq597h8zkms";
  k3sVendorSha256 = "sha256-U67tJRGqPFk5AfRe7I50zKGC9HJ2oh+iI/C7qF/76BQ=";

  # taken from ./manifests/traefik.yaml, extracted from '.spec.chart' https://github.com/k3s-io/k3s/blob/v1.23.3%2Bk3s1/scripts/download#L9
  # The 'patch' and 'minor' versions are currently hardcoded as single digits only, so ignore the trailing two digits. Weird, I know.
  traefikChartVersion = "12.0.0";
  traefikChartSha256 = "1sqmi71fi3ad5dh5fmsp9mv80x6pkgqwi4r9fr8l6i9sdnai6f1a";

  # taken from ./scripts/version.sh VERSION_ROOT https://github.com/k3s-io/k3s/blob/v1.23.3%2Bk3s1/scripts/version.sh#L47
  k3sRootVersion = "0.11.0";
  k3sRootSha256 = "016n56vi09xkvjph7wgzb2m86mhd5x65fs4d11pmh20hl249r620";

  # taken from ./scripts/version.sh VERSION_CNIPLUGINS https://github.com/k3s-io/k3s/blob/v1.23.3%2Bk3s1/scripts/version.sh#L45
  k3sCNIVersion = "1.1.1-k3s1";
  k3sCNISha256 = "14mb3zsqibj1sn338gjmsyksbm0mxv9p016dij7zidccx2rzn6nl";

  # taken from go.mod, the 'github.com/containerd/containerd' line
  # run `grep github.com/containerd/containerd go.mod | head -n1 | awk '{print $4}'`
  containerdVersion = "1.5.13-k3s2";
  containerdSha256 = "1pfr2ji4aij9js90gf4a3hqnhyw5hshcjdccm62l700j68gs5z97";

  # run `grep github.com/kubernetes-sigs/cri-tools go.mod | head -n1 | awk '{print $4}'` in the k3s repo at the tag
  criCtlVersion = "1.25.0-k3s1";

  baseMeta = k3s.meta;

  # https://github.com/k3s-io/k3s/blob/5fb370e53e0014dc96183b8ecb2c25a61e891e76/scripts/build#L19-L40
  versionldflags = [
    "-X github.com/rancher/k3s/pkg/version.Version=v${k3sVersion}"
    "-X github.com/rancher/k3s/pkg/version.GitCommit=${lib.substring 0 8 k3sCommit}"
    "-X k8s.io/client-go/pkg/version.gitVersion=v${k3sVersion}"
    "-X k8s.io/client-go/pkg/version.gitCommit=${k3sCommit}"
    "-X k8s.io/client-go/pkg/version.gitTreeState=clean"
    "-X k8s.io/client-go/pkg/version.buildDate=1970-01-01T01:01:01Z"
    "-X k8s.io/component-base/version.gitVersion=v${k3sVersion}"
    "-X k8s.io/component-base/version.gitCommit=${k3sCommit}"
    "-X k8s.io/component-base/version.gitTreeState=clean"
    "-X k8s.io/component-base/version.buildDate=1970-01-01T01:01:01Z"
    "-X github.com/kubernetes-sigs/cri-tools/pkg/version.Version=v${criCtlVersion}"
    "-X github.com/containerd/containerd/version.Version=v${containerdVersion}"
    "-X github.com/containerd/containerd/version.Package=github.com/k3s-io/containerd"
  ];

  # bundled into the k3s binary
  traefikChart = fetchurl {
    url = "https://helm.traefik.io/traefik/traefik-${traefikChartVersion}.tgz";
    sha256 = traefikChartSha256;
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
    url = "https://github.com/k3s-io/k3s-root/releases/download/v${k3sRootVersion}/k3s-root-amd64.tar";
    sha256 = k3sRootSha256;
    stripRoot = false;
  };
  k3sCNIPlugins = buildGoModule rec {
    pname = "k3s-cni-plugins";
    version = k3sCNIVersion;
    vendorSha256 = null;

    subPackages = [ "." ];

    src = fetchFromGitHub {
      owner = "rancher";
      repo = "plugins";
      rev = "v${version}";
      sha256 = k3sCNISha256;
    };

    postInstall = ''
      mv $out/bin/plugins $out/bin/cni
    '';

    meta = baseMeta // {
      description = "CNI plugins, as patched by rancher for k3s";
    };
  };
  # Grab this separately from a build because it's used by both stages of the
  # k3s build.
  k3sRepo = fetchgit {
    url = "https://github.com/k3s-io/k3s";
    rev = "v${k3sVersion}";
    sha256 = k3sRepoSha256;
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
  # correctly built to run with nix (we can lean on the existing buildGoModule
  # stuff), and we can again lean on that tooling for the final k3s binary too.
  # Other alternatives would be to manually run the
  # strip/patchelf/remove-references step ourselves in the installPhase of the
  # derivation when we've built all the binaries, but haven't bundled them in
  # with generated bindata yet.

  k3sServer = buildGoModule rec {
    pname = "k3s-server";
    version = k3sVersion;

    src = k3sRepo;
    vendorSha256 = k3sVendorSha256;

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libseccomp ];

    subPackages = [ "cmd/server" ];
    ldflags = versionldflags;

    # create the multicall symlinks for k3s
    postInstall = ''
      mv $out/bin/server $out/bin/k3s
      pushd $out
      # taken verbatim from https://github.com/k3s-io/k3s/blob/v1.23.3%2Bk3s1/scripts/build#L105-L113
      ln -s k3s ./bin/k3s-agent
      ln -s k3s ./bin/k3s-server
      ln -s k3s ./bin/k3s-etcd-snapshot
      ln -s k3s ./bin/k3s-secrets-encrypt
      ln -s k3s ./bin/k3s-certificate
      ln -s k3s ./bin/kubectl
      ln -s k3s ./bin/crictl
      ln -s k3s ./bin/ctr
      popd
    '';

    meta = baseMeta // {
      description = "The various binaries that get packaged into the final k3s binary";
    };
  };
  k3sContainerd = buildGoModule {
    pname = "k3s-containerd";
    version = containerdVersion;
    src = fetchFromGitHub {
      owner = "k3s-io";
      repo = "containerd";
      rev = "v${containerdVersion}";
      sha256 = containerdSha256;
    };
    vendorSha256 = null;
    buildInputs = [ btrfs-progs ];
    subPackages = [ "cmd/containerd" "cmd/containerd-shim-runc-v2" ];
    ldflags = versionldflags;
  };
in
buildGoModule rec {
  pname = "k3s";
  version = k3sVersion;

  src = k3sRepo;
  vendorSha256 = k3sVendorSha256;

  patches = [
    ./0001-script-download-strip-downloading-just-package-CRD.patch
  ];

  postPatch = ''
    # Nix prefers dynamically linked binaries over static binary.

    substituteInPlace scripts/package-cli \
      --replace '"$LDFLAGS $STATIC" -o' \
                '"$LDFLAGS" -o' \
      --replace "STATIC=\"-extldflags \'-static\'\"" \
                ""

    # Upstream codegen fails with trimpath set. Removes "trimpath" for 'go generate':

    substituteInPlace scripts/package-cli \
      --replace '"''${GO}" generate' \
                'GOFLAGS="" \
                 GOOS="${pkgsBuildBuild.go.GOOS}" \
                 GOARCH="${pkgsBuildBuild.go.GOARCH}" \
                 CC="${pkgsBuildBuild.stdenv.cc}/bin/cc" \
                 "''${GO}" generate'
  '';

  # Important utilities used by the kubelet, see
  # https://github.com/kubernetes/kubernetes/issues/26093#issuecomment-237202494
  # Note the list in that issue is stale and some aren't relevant for k3s.
  k3sRuntimeDeps = [
    kmod
    socat
    iptables
    iproute2
    bridge-utils
    ethtool
    util-linux # kubelet wants 'nsenter' from util-linux: https://github.com/kubernetes/kubernetes/issues/26093#issuecomment-705994388
    conntrack-tools
  ];

  buildInputs = k3sRuntimeDeps;

  nativeBuildInputs = [
    makeWrapper
    rsync
    yq-go
    zstd
  ];

  # embedded in the final k3s cli
  propagatedBuildInputs = [
    k3sCNIPlugins
    k3sContainerd
    k3sServer
    runc
  ];

  # We override most of buildPhase due to peculiarities in k3s's build.
  # Specifically, it has a 'go generate' which runs part of the package. See
  # this comment:
  # https://github.com/NixOS/nixpkgs/pull/158089#discussion_r799965694
  # So, why do we use buildGoModule at all? For the `vendorSha256` / `go mod download` stuff primarily.
  buildPhase = ''
    patchShebangs ./scripts/package-cli ./scripts/download ./scripts/build-upload

    # copy needed 'go generate' inputs into place
    mkdir -p ./bin/aux
    rsync -a --no-perms ${k3sServer}/bin/ ./bin/
    ln -vsf ${runc}/bin/runc ./bin/runc
    ln -vsf ${k3sCNIPlugins}/bin/cni ./bin/cni
    ln -vsf ${k3sContainerd}/bin/* ./bin/
    rsync -a --no-perms --chmod u=rwX ${k3sRoot}/etc/ ./etc/
    mkdir -p ./build/static/charts
    # Note, upstream's chart has a 00 suffix. This seems to not matter though, so we're ignoring that naming detail.
    export TRAEFIK_CHART_FILE=${traefikChart}
    # place the traefik chart using their code since it's complicated
    # We trim the actual download, see patches
    ./scripts/download

    export ARCH=$GOARCH
    export DRONE_TAG="v${k3sVersion}"
    export DRONE_COMMIT="${k3sCommit}"
    # use ./scripts/package-cli to run 'go generate' + 'go build'

    ./scripts/package-cli
    mkdir -p $out/bin
  '';

  # Otherwise it depends on 'getGoDirs', which is normally set in buildPhase
  doCheck = false;

  installPhase = ''
    # wildcard to match the arm64 build too
    install -m 0755 dist/artifacts/k3s* -D $out/bin/k3s
    wrapProgram $out/bin/k3s \
      --prefix PATH : ${lib.makeBinPath k3sRuntimeDeps} \
      --prefix PATH : "$out/bin"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/k3s --version | grep -F "v${k3sVersion}" >/dev/null
  '';

  # Fix-Me: Needs to be adapted specifically for 1.25
  # passthru.updateScript = ./update.sh;

  passthru.tests = k3s.passthru.mkTests k3sVersion;

  meta = baseMeta;
}

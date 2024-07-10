lib:
{
  # git tag
  k3sVersion,
  # commit hash
  k3sCommit,
  k3sRepoSha256 ? lib.fakeHash,
  k3sVendorHash ? lib.fakeHash,
  # taken from ./scripts/version.sh VERSION_ROOT https://github.com/k3s-io/k3s/blob/v1.23.3%2Bk3s1/scripts/version.sh#L47
  k3sRootVersion,
  k3sRootSha256 ? lib.fakeHash,
  # Based on the traefik charts here: https://github.com/k3s-io/k3s/blob/d71ab6317e22dd34673faa307a412a37a16767f6/scripts/download#L29-L32
  # see also https://github.com/k3s-io/k3s/blob/d71ab6317e22dd34673faa307a412a37a16767f6/manifests/traefik.yaml#L8
  chartVersions,
  # taken from ./scripts/version.sh VERSION_CNIPLUGINS https://github.com/k3s-io/k3s/blob/v1.23.3%2Bk3s1/scripts/version.sh#L45
  k3sCNIVersion,
  k3sCNISha256 ? lib.fakeHash,
  # taken from ./scripts/version.sh VERSION_CONTAINERD
  containerdVersion,
  containerdSha256 ? lib.fakeHash,
  # run `grep github.com/kubernetes-sigs/cri-tools go.mod | head -n1 | awk '{print $4}'` in the k3s repo at the tag
  criCtlVersion,
  updateScript ? null,
}:

# builder.nix contains a "builder" expression that, given k3s version and hash
# variables, creates a package for that version.
# Due to variance in k3s's build process, this builder only works for k3s 1.26+
# currently.
# It is likely we will have to split out additional builders for additional
# versions in the future, or customize this one further.
{
  lib,
  makeWrapper,
  socat,
  iptables,
  iproute2,
  ipset,
  bridge-utils,
  btrfs-progs,
  conntrack-tools,
  buildGoModule,
  runc,
  rsync,
  kmod,
  libseccomp,
  pkg-config,
  ethtool,
  util-linux,
  fetchFromGitHub,
  fetchurl,
  fetchzip,
  fetchgit,
  zstd,
  yq-go,
  sqlite,
  nixosTests,
  pkgsBuildBuild,
  go,
  runCommand,
  bash,
  procps,
  coreutils,
  gnugrep,
  findutils,
  gnused,
  systemd,
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

  baseMeta = with lib; {
    description = "Lightweight Kubernetes distribution";
    license = licenses.asl20;
    homepage = "https://k3s.io";
    maintainers = with maintainers; [
      euank
      mic92
      superherointj
      wrmilling
      yajo
    ];
    platforms = platforms.linux;

    # resolves collisions with other installations of kubectl, crictl, ctr
    # prefer non-k3s versions
    priority = 5;
  };

  # https://github.com/k3s-io/k3s/blob/5fb370e53e0014dc96183b8ecb2c25a61e891e76/scripts/build#L19-L40
  versionldflags = [
    "-X github.com/k3s-io/k3s/pkg/version.Version=v${k3sVersion}"
    "-X github.com/k3s-io/k3s/pkg/version.GitCommit=${lib.substring 0 8 k3sCommit}"
    "-X github.com/k3s-io/k3s/pkg/version.UpstreamGolang=go${go.version}"
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
  traefikChart = fetchurl chartVersions.traefik;
  traefik-crdChart = fetchurl chartVersions.traefik-crd;

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
    vendorHash = null;

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

  # Modify the k3s installer script so that we can let it install only
  # killall.sh
  k3sKillallSh = runCommand "k3s-killall.sh" { } ''
    # Copy the upstream k3s install script except for the last lines that
    # actually run the install process
    sed --quiet '/# --- run the install process --/q;p' ${k3sRepo}/install.sh > install.sh

    # Let killall expect "containerd-shim" in the Nix store
    to_replace="k3s/data/\[\^/\]\*/bin/containerd-shim"
    replacement="/nix/store/.*k3s-containerd.*/bin/containerd-shim"
    changes=$(sed -i "s|$to_replace|$replacement| w /dev/stdout" install.sh)
    if [ -z "$changes" ]; then
      echo "failed to replace \"$to_replace\" in k3s installer script (install.sh)"
      exit 1
    fi

    remove_matching_line() {
      line_to_delete=$(grep -n "$1" install.sh | cut -d : -f 1 || true)
      if [ -z $line_to_delete ]; then
        echo "failed to find expression \"$1\" in k3s installer script (install.sh)"
        exit 1
      fi
      sed -i "''${line_to_delete}d" install.sh
    }

    # Don't change mode and owner of killall
    remove_matching_line "chmod.*KILLALL_K3S_SH"
    remove_matching_line "chown.*KILLALL_K3S_SH"

    # Execute only the "create_killall" function of the installer script
    sed -i '$acreate_killall' install.sh

    KILLALL_K3S_SH=$out bash install.sh
  '';

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

  k3sServer = buildGoModule {
    pname = "k3s-server";
    version = k3sVersion;

    src = k3sRepo;
    vendorHash = k3sVendorHash;

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [
      libseccomp
      sqlite.dev
    ];

    subPackages = [ "cmd/server" ];
    ldflags = versionldflags;

    tags = [
      "ctrd"
      "libsqlite3"
      "linux"
    ];

    # create the multicall symlinks for k3s
    postInstall = ''
      mv $out/bin/server $out/bin/k3s
      pushd $out
      # taken verbatim from https://github.com/k3s-io/k3s/blob/v1.23.3%2Bk3s1/scripts/build#L105-L113
      ln -s k3s ./bin/containerd
      ln -s k3s ./bin/crictl
      ln -s k3s ./bin/ctr
      ln -s k3s ./bin/k3s-agent
      ln -s k3s ./bin/k3s-certificate
      ln -s k3s ./bin/k3s-completion
      ln -s k3s ./bin/k3s-etcd-snapshot
      ln -s k3s ./bin/k3s-secrets-encrypt
      ln -s k3s ./bin/k3s-server
      ln -s k3s ./bin/k3s-token
      ln -s k3s ./bin/kubectl
      popd
    '';

    meta = baseMeta // {
      description = "Various binaries that get packaged into the final k3s binary";
    };
  };
  # Only used for the shim since
  # https://github.com/k3s-io/k3s/blob/v1.27.2%2Bk3s1/scripts/build#L153
  k3sContainerd = buildGoModule {
    pname = "k3s-containerd";
    version = containerdVersion;
    src = fetchFromGitHub {
      owner = "k3s-io";
      repo = "containerd";
      rev = "v${containerdVersion}";
      sha256 = containerdSha256;
    };
    vendorHash = null;
    buildInputs = [ btrfs-progs ];
    subPackages = [ "cmd/containerd-shim-runc-v2" ];
    ldflags = versionldflags;
  };
in
buildGoModule rec {
  pname = "k3s";
  version = k3sVersion;

  tags = [
    "libsqlite3"
    "linux"
    "ctrd"
  ];
  src = k3sRepo;
  vendorHash = k3sVendorHash;

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
    ipset
    bridge-utils
    ethtool
    util-linux # kubelet wants 'nsenter' from util-linux: https://github.com/kubernetes/kubernetes/issues/26093#issuecomment-705994388
    conntrack-tools
    runc
    bash
  ];

  k3sKillallDeps = [
    bash
    systemd
    procps
    coreutils
    gnugrep
    findutils
    gnused
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
  ];

  # We override most of buildPhase due to peculiarities in k3s's build.
  # Specifically, it has a 'go generate' which runs part of the package. See
  # this comment:
  # https://github.com/NixOS/nixpkgs/pull/158089#discussion_r799965694
  # So, why do we use buildGoModule at all? For the `vendorHash` / `go mod download` stuff primarily.
  buildPhase = ''
    patchShebangs ./scripts/package-cli ./scripts/download ./scripts/build-upload

    # copy needed 'go generate' inputs into place
    mkdir -p ./bin/aux
    rsync -a --no-perms ${k3sServer}/bin/ ./bin/
    ln -vsf ${k3sCNIPlugins}/bin/cni ./bin/cni
    ln -vsf ${k3sContainerd}/bin/containerd-shim-runc-v2 ./bin
    rsync -a --no-perms --chmod u=rwX ${k3sRoot}/etc/ ./etc/
    mkdir -p ./build/static/charts

    cp ${traefikChart} ./build/static/charts
    cp ${traefik-crdChart} ./build/static/charts

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
    ln -s $out/bin/k3s $out/bin/kubectl
    ln -s $out/bin/k3s $out/bin/crictl
    ln -s $out/bin/k3s $out/bin/ctr
    install -m 0755 ${k3sKillallSh} -D $out/bin/k3s-killall.sh
    wrapProgram $out/bin/k3s-killall.sh \
      --prefix PATH : ${lib.makeBinPath (k3sRuntimeDeps ++ k3sKillallDeps)}
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/k3s --version | grep -F "v${k3sVersion}" >/dev/null
  '';

  passthru.updateScript = updateScript;

  passthru.mkTests =
    version:
    let
      k3s_version = "k3s_" + lib.replaceStrings [ "." ] [ "_" ] (lib.versions.majorMinor version);
    in
    {
      etcd = nixosTests.k3s.etcd.${k3s_version};
      single-node = nixosTests.k3s.single-node.${k3s_version};
      multi-node = nixosTests.k3s.multi-node.${k3s_version};
    };
  passthru.tests = passthru.mkTests k3sVersion;

  meta = baseMeta;
}

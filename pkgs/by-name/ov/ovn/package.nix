{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  libbpf,
  libcap_ng,
  nix-update-script,
  numactl,
  openssl,
  pkg-config,
  procps,
  python3,
  unbound,
  xdp-tools,
  openvswitch,
  gawk,
  coreutils,
  gnugrep,
  gnused,
  makeWrapper,

  # test dependencies
  tcpdump,
  testers,
  util-linux,
  which,
}:
let
  withOpensslConfigureFlag = "--with-openssl=${lib.getLib openssl.dev}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ovn";
  version = "26.03.2";

  src = fetchFromGitHub {
    owner = "ovn-org";
    repo = "ovn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aIC9l9rCBcc+IaMEz1HJlcUDm7Q09htJXsGa+p3qk48=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ovn-org/ovn/commit/ac165c29df9c3a7ea44f9491f776535d15a7dabb.patch";
      hash = "sha256-i1nDVcHsM0ambvCvVhn+4krV3cW5Cbc3OvvGlyElaxg=";
    })
    (fetchpatch {
      url = "https://github.com/ovn-org/ovn/commit/944dded0f7eecb7456d6b85774bf9bc1df9cb0ac.patch";
      hash = "sha256-/vIWXUVWO+7SbYynMMmNOHAIjZFOfp1BzAV6g1yoYEc=";
    })
    (fetchpatch {
      url = "https://github.com/ovn-org/ovn/commit/1ce2794460c01967c8b674d12762ac7c1ce52091.patch";
      hash = "sha256-DprJiAVXk4XIfmt7ETQfmFxyo6a43qdv0W1FbPUZsPA=";
    })
    (fetchpatch {
      url = "https://github.com/ovn-org/ovn/commit/4d32c2f936ea1c5d0e1f3e924d779115f4c9731a.patch";
      hash = "sha256-kkrJRIf8YEf+Nwg1DVxU7AWpOaIjl6XiPyARquhYtkw=";
    })
    (fetchpatch {
      url = "https://github.com/ovn-org/ovn/commit/2d762d1934be14bb8d1cef3954e641cc4cf91fde.patch";
      hash = "sha256-OS7sU3QuRKt3xRxD6AybZICDOw1wioAQpNHsNf+8Ag4=";
    })
    (fetchpatch {
      url = "https://github.com/ovn-org/ovn/commit/5fb4cb24510e7db84550024c1448c1c76849325e.patch";
      hash = "sha256-sFXe8rtPwp70bdoE2eSk/11K+BnSTnoAYaVimDfOdko=";
    })
    (fetchpatch {
      url = "https://github.com/ovn-org/ovn/commit/bb14529390e52b727e9686fae336481bbbe53b68.patch";
      hash = "sha256-+bKM5UHM46p1caJdpSN+acLlXp7GCGCXuW6endmG1AY=";
    })
    (fetchpatch {
      url = "https://github.com/ovn-org/ovn/commit/d2f7f9ace6c08d8bc04ee243b940f417d2927998.patch";
      hash = "sha256-wiclwlS4t94R7PTRxpMsektbZum6/HjHGSR7DlCf4l8=";
    })
  ];

  outputs = [
    "out"
    "lib"
    "man"
    "dev"
    "tools"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    makeWrapper
    # NOTE: remove if OVN switches to `command -v`:
    # https://patchwork.ozlabs.org/project/ovn/patch/20260205004956.84602-3-ihar.hrachyshka@gmail.com/
    which # used in test suite to detect presence of commands
  ];

  buildInputs = [
    libcap_ng
    numactl
    openssl
    unbound
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
    libbpf
    xdp-tools
  ];

  # need to build the ovs submodule first
  preConfigure = ''
    pushd ovs
    ./boot.sh
    ./configure --with-dbdir=/var/lib/openvswitch ${lib.optionalString stdenv.hostPlatform.isStatic withOpensslConfigureFlag}
    make -j $NIX_BUILD_CORES
    popd
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sharedstatedir=/var"
    "--with-dbdir=/var/lib/ovn"
    "--sbindir=$(out)/bin"
    "--enable-ssl"
  ]
  ++ lib.optional stdenv.hostPlatform.isStatic withOpensslConfigureFlag;

  enableParallelBuilding = true;

  doCheck = true;

  nativeCheckInputs = [
    # used to generate certificates used for test services
    openssl
    procps

    # some tests may need tcpdump to run
    tcpdump

    # scapy-server imports scapy module
    (python3.withPackages (ps: with ps; [ scapy ]))

    # scapy tests use flock to start scapy-server
    util-linux
  ];

  postInstall = ''
    moveToOutput 'share/ovn/bugtool-plugins' "$tools"
    moveToOutput 'share/ovn/scripts/ovn-bugtool-*' "$tools"

    moveToOutput 'bin/ovn-detrace' "$tools"
    moveToOutput 'bin/ovn_detrace*' "$tools"
    moveToOutput 'bin/ovn-trace' "$tools"
    moveToOutput 'bin/ovn-debug' "$tools"
    moveToOutput 'bin/ovn-docker*' "$tools"

    sed -i '/chown -R $INSTALL_USER:$INSTALL_GROUP $ovn_etcdir/d' $out/share/ovn/scripts/ovn-ctl

    mkdir -vp $out/share/openvswitch/scripts
    ln -s ${openvswitch}/share/openvswitch/scripts/ovs-lib $out/share/openvswitch/scripts/ovs-lib

    wrapProgram $out/share/ovn/scripts/ovn-ctl \
      --prefix PATH : ${
        lib.makeBinPath [
          openvswitch
          gawk
          coreutils # tr
          gnugrep
          gnused
        ]
      }
  '';

  env = {
    SKIP_UNSTABLE = "yes";
  };

  # https://docs.ovn.org/en/latest/topics/testing.html
  preCheck = ''
    export TESTSUITEFLAGS="-j$NIX_BUILD_CORES"
    # allow rechecks to retry flaky tests
    export RECHECK=yes

    # hack to stop tests from trying to read /etc/resolv.conf
    export OVS_RESOLV_CONF="$PWD/resolv.conf"
    touch $OVS_RESOLV_CONF

    patchShebangs --build tests/scapy-server.py
  '';

  checkPhase = ''
    runHook preCheck

    if ! make check; then
      echo "Some tests failed. Collecting logs for analysis..."
      find tests/testsuite.dir -type f -exec echo "==== Contents of {} ====" \; -exec cat {} \;
      exit 1
    fi

    runHook postCheck
  '';

  passthru = {
    tests =
      let
        systemTestData = finalAttrs.finalPackage.overrideAttrs {
          doCheck = false;
          outputs = [ "out" ];
          installPhase = "cp -a . $out";
          postInstall = "";
          dontFixup = true;
        };

        mkSystemTest =
          mode: makeTarget:
          testers.runNixOSTest {
            name = "ovn-system-tests-${mode}";

            nodes.machine = { pkgs, ... }: {
              environment.systemPackages = with pkgs; [
                bc
                curl
                ethtool
                gnumake
                iproute2
                iputils
                kmod
                net-tools
                nfdump
                nftables
                nmap
                openssl
                procps
                tcpdump
                util-linux
                wget
                which
                (python3.withPackages (ps: [ ps.scapy ]))
              ];

              virtualisation = {
                cores = 4;
                diskSize = 8192;
                memorySize = 4096;
              };
            };

            testScript = ''
              machine.succeed(
                  "mkdir -p /build",
                  # Makefiles contain absolute references to the build directory.
                  "cp -a ${systemTestData} /build/source",
                  "chmod -R u+w /build/source",
                  "SKIP_UNSTABLE=yes make -C /build/source ${makeTarget}",
              )
            '';
          };
      in
      {
        system-userspace = mkSystemTest "userspace" "check-system-userspace";
        system-kernel = mkSystemTest "kernel" "check-kernel";
      };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open Virtual Network";
    longDescription = ''
      OVN (Open Virtual Network) is a series of daemons that translates virtual network configuration into OpenFlow, and installs them into Open vSwitch.
    '';
    homepage = "https://www.ovn.org";
    changelog = "https://github.com/ovn-org/ovn/blob/refs/tags/${finalAttrs.src.tag}/NEWS";
    license = with lib.licenses; [
      asl20
      lgpl21Plus # bugtool plugins
      sissl11 # lib/sflow from ovs submodule
    ];
    maintainers = with lib.maintainers; [
      adamcstephens
      booxter
    ];
    platforms = lib.platforms.linux;
  };
})

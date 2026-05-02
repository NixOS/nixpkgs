{
  lib,
  stdenv,
  fetchFromGitHub,
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
  which,
  util-linux,
  tcpdump,
}:
let
  withOpensslConfigureFlag = "--with-openssl=${lib.getLib openssl.dev}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ovn";
  version = "26.03.1";

  src = fetchFromGitHub {
    owner = "ovn-org";
    repo = "ovn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m2YEFyIBrXUo4mxdDJ9bgVeWUxefi9muJ9iGtnq3bgs=";
    fetchSubmodules = true;
  };

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

  passthru.updateScript = nix-update-script { };

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

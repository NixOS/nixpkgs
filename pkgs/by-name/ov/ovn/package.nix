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
  makeWrapper,
}:
let
  withOpensslConfigureFlag = "--with-openssl=${lib.getLib openssl.dev}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ovn";
  version = "25.09.0";

  src = fetchFromGitHub {
    owner = "ovn-org";
    repo = "ovn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DNaf3vWb6tlzViMEI02+3st/0AiMVAomSaiGplcjkIc=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "lib"
    "man"
    "dev"
    "tools"
  ];

  patches = [
    # Fix test failure with musl libc.
    (fetchpatch {
      url = "https://github.com/ovn-org/ovn/commit/d0b187905c45ce039163d18cc82869918946a41c.patch";
      hash = "sha256-mTpNpH1ZSSMLtpZmy6jKjGDu84jL0ECr+HVh1PQzaVA=";
    })
    # Fix sandbox test failure.
    (fetchpatch {
      url = "https://github.com/ovn-org/ovn/commit/b396babaa54ea0c8d943bbfef751dbdbf288c7af.patch";
      hash = "sha256-RjWxT3EYKjGhtvCq3bAhKN9PrPTkSR72xPkQQ4SPWWU=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    makeWrapper
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
    openssl # used to generate certificates used for test services
    procps
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
      --prefix PATH : ${lib.makeBinPath [ openvswitch ]}
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

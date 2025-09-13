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

  patches = [
    # Fix test failure with musl libc.
    # https://patchwork.ozlabs.org/project/ovn/patch/20250912035054.50593-1-ihar.hrachyshka@gmail.com/
    ./0001-tests-Expect-musl-error-string-for-EIO-errno.patch
    # Fix sandbox test failure.
    # https://patchwork.ozlabs.org/project/ovn/patch/20250912035054.50593-2-ihar.hrachyshka@gmail.com/
    ./0002-tests-Use-localhost-when-setting-wrong-ovn-remote.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
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
    mkdir -vp $out/share/openvswitch/scripts
    mkdir -vp $out/etc/ovn
    cp ovs/ovsdb/ovsdb-client $out/bin
    cp ovs/ovsdb/ovsdb-server $out/bin
    cp ovs/ovsdb/ovsdb-tool $out/bin
    cp ovs/vswitchd/ovs-vswitchd $out/bin
    cp ovs/utilities/ovs-appctl $out/bin
    cp ovs/utilities/ovs-vsctl $out/bin
    cp ovs/utilities/ovs-ctl $out/share/openvswitch/scripts
    cp ovs/utilities/ovs-lib $out/share/openvswitch/scripts
    cp ovs/utilities/ovs-kmod-ctl $out/share/openvswitch/scripts
    cp ovs/vswitchd/vswitch.ovsschema $out/share/openvswitch
    sed -i "s#/usr/local/etc#/var/lib#g" $out/share/openvswitch/scripts/ovs-lib
    sed -i "s#/usr/local/bin#$out/bin#g" $out/share/openvswitch/scripts/ovs-lib
    sed -i "s#/usr/local/sbin#$out/bin#g" $out/share/openvswitch/scripts/ovs-lib
    sed -i "s#/usr/local/share#$out/share#g" $out/share/openvswitch/scripts/ovs-lib
    sed -i '/chown -R $INSTALL_USER:$INSTALL_GROUP $ovn_etcdir/d' $out/share/ovn/scripts/ovn-ctl
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      adamcstephens
      booxter
    ];
    platforms = lib.platforms.linux;
  };
})

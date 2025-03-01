{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gnused,
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

stdenv.mkDerivation rec {
  pname = "ovn";
  version = "24.09.2";

  src = fetchFromGitHub {
    owner = "ovn-org";
    repo = "ovn";
    tag = "v${version}";
    hash = "sha256-MKwta7XRIFpcNWu6duuNaLarlWm0B8+gph1R0qS29wI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    libbpf
    libcap_ng
    numactl
    openssl
    unbound
    xdp-tools
  ];

  # need to build the ovs submodule first
  preConfigure = ''
    pushd ovs
    ./boot.sh
    ./configure --with-dbdir=/var/lib/openvswitch
    make -j $NIX_BUILD_CORES
    popd
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sharedstatedir=/var"
    "--with-dbdir=/var/lib/ovn"
    "--sbindir=$(out)/bin"
    "--enable-ssl"
  ];

  enableParallelBuilding = true;

  # disable tests due to networking issues and because individual tests can't be skipped easily
  doCheck = false;

  nativeCheckInputs = [
    gnused
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

  meta = with lib; {
    description = "Open Virtual Network";
    longDescription = ''
      OVN (Open Virtual Network) is a series of daemons that translates virtual network configuration into OpenFlow, and installs them into Open vSwitch.
    '';
    homepage = "https://github.com/ovn-org/ovn";
    changelog = "https://github.com/ovn-org/ovn/blob/${src.rev}/NEWS";
    license = licenses.asl20;
    maintainers = with maintainers; [ adamcstephens ];
    platforms = platforms.linux;
  };
}

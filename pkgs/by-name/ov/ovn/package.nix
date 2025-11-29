{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
}:
let
  withOpensslConfigureFlag = "--with-openssl=${lib.getLib openssl.dev}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ovn";
  version = "25.09.1";

  src = fetchFromGitHub {
    owner = "ovn-org";
    repo = "ovn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-utNMWYMjm511+mkHC/Fe6wJ11vk1HAi0dHlk9JwBYl0=";
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
    # Fix build failure due to make install race condition.
    # Posted at: https://patchwork.ozlabs.org/project/ovn/patch/20251012225908.37855-1-ihar.hrachyshka@gmail.com/
    ./0001-build-Fix-race-condition-when-installing-ovn-detrace.patch

    # disable scapy tests which hang indefinitely
    (fetchpatch2 {
      name = "disable-scapy-tests.patch";
      url = "https://github.com/ovn-org/ovn/commit/df99035f88e43a3b80f4c58dc530fd3f45766c54.patch?full_index=1";
      hash = "sha256-Ofbbu/j5ox3Tp0q62KrfOdMbuxenwofGdushRAmVQGI=";
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

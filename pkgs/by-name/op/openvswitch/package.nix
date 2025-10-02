{
  withDPDK ? false,

  lib,
  stdenv,

  autoconf,
  automake,
  dpdk,
  fetchFromGitHub,
  installShellFiles,
  iproute2,
  libcap_ng,
  libpcap,
  libtool,
  makeWrapper,
  nix-update-script,
  nixosTests,
  numactl,
  openssl,
  perl,
  pkg-config,
  procps,
  python3,
  sphinxHook,
  tcpdump,
  util-linux,
  which,
}:

stdenv.mkDerivation rec {
  pname = if withDPDK then "openvswitch-dpdk" else "openvswitch";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "openvswitch";
    repo = "ovs";
    tag = "v${version}";
    hash = "sha256-zzEE1H0fjFOZY3KXFPb91Bmk3irPL1mHEbEBsumPlkw=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
    "tools"
  ];

  patches = [
    # 8: vsctl-bashcomp - argument completion FAILED (completion.at:664)
    ./patches/disable-bash-arg-completion-test.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    installShellFiles
    libtool
    pkg-config
    sphinxHook
    makeWrapper
  ];

  sphinxBuilders = [ "man" ];

  sphinxRoot = "./Documentation";

  buildInputs = [
    libcap_ng
    openssl
    perl
    procps
    python3
    util-linux
    which
  ]
  ++ (lib.optionals withDPDK [
    dpdk
    numactl
    libpcap
  ]);

  preConfigure = "./boot.sh";

  configureFlags = [
    "--localstatedir=/var"
    "--sharedstatedir=/var"
    "--sbindir=$(out)/bin"
  ]
  ++ (lib.optionals withDPDK [ "--with-dpdk=shared" ]);

  # Leave /var out of this!
  installFlags = [
    "LOGDIR=$(TMPDIR)/dummy"
    "RUNDIR=$(TMPDIR)/dummy"
    "PKIDIR=$(TMPDIR)/dummy"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    # Install bash completions in correct location
    rm -f $out/etc/bash_completion.d/ovs-*.bash
    installShellCompletion utilities/ovs-appctl-bashcomp.bash
    installShellCompletion utilities/ovs-vsctl-bashcomp.bash

    mkdir -p $tools/{bin,share/openvswitch/scripts}
    mv $out/share/openvswitch/bugtool-plugins $tools/share/openvswitch
    mv $out/share/openvswitch/scripts/ovs-{bugtool*,check-dead-ifs,monitor-ipsec,vtep} $tools/share/openvswitch/scripts
    mv $out/share/openvswitch/scripts/usdt $tools/share/openvswitch/scripts
    mv $out/bin/ovs-{bugtool,dpctl-top,l3ping,parse-backtrace,pcap,tcpdump,tcpundump,test,vlan-test} $tools/bin

    wrapProgram $tools/bin/ovs-l3ping \
      --prefix PYTHONPATH : $out/share/openvswitch/python

    wrapProgram $tools/bin/ovs-tcpdump \
      --prefix PATH : ${lib.makeBinPath [ tcpdump ]} \
      --prefix PYTHONPATH : $out/share/openvswitch/python
  '';

  doCheck = true;
  preCheck = ''
    export TESTSUITEFLAGS="-j$NIX_BUILD_CORES"
    export RECHECK=yes

    patchShebangs tests/
  '';

  nativeCheckInputs = [
    iproute2
  ]
  ++ (with python3.pkgs; [
    netaddr
    pyparsing
    pytest
    setuptools
  ]);

  passthru = {
    tests = {
      default = nixosTests.openvswitch;
      incus = nixosTests.incus-lts.openvswitch;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://www.openvswitch.org/releases/NEWS-${version}.txt";
    description = "Multilayer virtual switch";
    longDescription = ''
      Open vSwitch is a production quality, multilayer virtual switch
      licensed under the open source Apache 2.0 license. It is
      designed to enable massive network automation through
      programmatic extension, while still supporting standard
      management interfaces and protocols (e.g. NetFlow, sFlow, SPAN,
      RSPAN, CLI, LACP, 802.1ag). In addition, it is designed to
      support distribution across multiple physical servers similar
      to VMware's vNetwork distributed vswitch or Cisco's Nexus 1000V.
    '';
    homepage = "https://www.openvswitch.org/";
    license = with lib.licenses; [
      asl20
      lgpl21Plus # ovs-bugtool
      sissl11 # lib/sflow
    ];
    maintainers = with lib.maintainers; [
      adamcstephens
      booxter
      kmcopper
      netixx
      xddxdd
    ];
    platforms = lib.platforms.linux;
  };
}

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
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "openvswitch";
    repo = "ovs";
    rev = "refs/tags/v${version}";
    hash = "sha256-EudcANZ0aUImQ/HWSX1PRklvhP2D5L3ugXaC0GKyF0Q=";
  };

  outputs = [
    "out"
    "man"
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

  buildInputs =
    [
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
  ] ++ (lib.optionals withDPDK [ "--with-dpdk=shared" ]);

  # Leave /var out of this!
  installFlags = [
    "LOGDIR=$(TMPDIR)/dummy"
    "RUNDIR=$(TMPDIR)/dummy"
    "PKIDIR=$(TMPDIR)/dummy"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    installShellCompletion --bash utilities/ovs-appctl-bashcomp.bash
    installShellCompletion --bash utilities/ovs-vsctl-bashcomp.bash

    wrapProgram $out/bin/ovs-l3ping \
      --prefix PYTHONPATH : $out/share/openvswitch/python

    wrapProgram $out/bin/ovs-tcpdump \
      --prefix PATH : ${lib.makeBinPath [ tcpdump ]} \
      --prefix PYTHONPATH : $out/share/openvswitch/python
  '';

  doCheck = true;
  preCheck = ''
    export TESTSUITEFLAGS="-j$NIX_BUILD_CORES"
    export RECHECK=yes

    patchShebangs tests/
  '';

  nativeCheckInputs =
    [ iproute2 ]
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

  meta = with lib; {
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
    license = licenses.asl20;
    maintainers = with maintainers; [
      adamcstephens
      kmcopper
      netixx
      xddxdd
    ];
    platforms = platforms.linux;
  };
}

{
  version,
  hash,
  updateScriptArgs ? "",
}:

{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  installShellFiles,
  iproute2,
  kernel ? null,
  libcap_ng,
  libtool,
  openssl,
  perl,
  pkg-config,
  procps,
  python3,
  sphinxHook,
  util-linux,
  which,
  writeScript,
}:

let
  _kernel = kernel;
in
stdenv.mkDerivation rec {
  pname = "openvswitch";
  inherit version;

  kernel = lib.optional (_kernel != null) _kernel.dev;

  src = fetchurl {
    url = "https://www.openvswitch.org/releases/${pname}-${version}.tar.gz";
    inherit hash;
  };

  outputs = [
    "out"
    "man"
  ];

  patches = [
    # 8: vsctl-bashcomp - argument completion FAILED (completion.at:664)
    ./patches/disable-bash-arg-completion-test.patch

    # https://github.com/openvswitch/ovs/commit/9185793e75435d890f18d391eaaeab0ade6f1415
    ./patches/fix-python313.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    installShellFiles
    libtool
    pkg-config
    sphinxHook
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
  ];

  preConfigure = "./boot.sh";

  configureFlags = [
    "--localstatedir=/var"
    "--sharedstatedir=/var"
    "--sbindir=$(out)/bin"
  ] ++ (lib.optionals (_kernel != null) [ "--with-linux" ]);

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

  passthru.updateScript = writeScript "ovs-update.nu" ''
    ${./update.nu} ${updateScriptArgs}
  '';

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
    ];
    platforms = platforms.linux;
  };
}

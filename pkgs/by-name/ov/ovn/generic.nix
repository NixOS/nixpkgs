{
  version,
  hash,
  updateScriptArgs ? "",
}:

{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gnused,
  libbpf,
  libcap_ng,
  numactl,
  openssl,
  pkg-config,
  procps,
  python3,
  unbound,
  xdp-tools,
  writeScript,
}:

stdenv.mkDerivation rec {
  pname = "ovn";
  inherit version;

  src = fetchFromGitHub {
    owner = "ovn-org";
    repo = "ovn";
    rev = "refs/tags/v${version}";
    inherit hash;
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
    ./configure
    make -j $NIX_BUILD_CORES
    popd
  '';

  enableParallelBuilding = true;

  doCheck = true;

  nativeCheckInputs = [
    gnused
    procps
  ];

  # https://docs.ovn.org/en/latest/topics/testing.html
  preCheck = ''
    export TESTSUITEFLAGS="-j$NIX_BUILD_CORES"
    # allow rechecks to retry flaky tests
    export RECHECK=yes

    # hack to stop tests from trying to read /etc/resolv.conf
    export OVS_RESOLV_CONF="$PWD/resolv.conf"
    touch $OVS_RESOLV_CONF
  '';

  passthru.updateScript = writeScript "ovs-update.nu" ''
    ${./update.nu} ${updateScriptArgs}
  '';

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

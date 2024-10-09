{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  flex,
  bison,
  python3,
  autoconf,
  which,
  help2man,
  makeWrapper,
  systemc,
  git,
  numactl,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "5.026";

  # Verilator gets the version from this environment variable
  # if it can't do git describe while building.
  VERILATOR_SRC_VERSION = "v${version}";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ds6w95tqlKjIFnkq2kKyslprKCwMOtBOoy7LuTon3KM=";
  };

  enableParallelBuilding = true;
  buildInputs = [
    perl
    python3
    systemc
    # ccache
  ];
  nativeBuildInputs = [
    makeWrapper
    flex
    bison
    autoconf
    help2man
    git
  ];
  nativeCheckInputs = [
    which
    numactl
    coreutils
    # cmake
  ];

  doCheck = stdenv.hostPlatform.isLinux; # darwin tests are broken for now...
  checkTarget = "test";

  preConfigure = "autoconf";

  postPatch = ''
    patchShebangs bin/* src/* nodist/* docs/bin/* examples/xml_py/* \
    test_regress/{driver.pl,t/*.{pl,pf}} \
    ci/* ci/docker/run/* ci/docker/run/hooks/* ci/docker/buildenv/build.sh
    # verilator --gdbbt uses /bin/echo to test if gdb works.
    sed -i 's|/bin/echo|${coreutils}\/bin\/echo|' bin/verilator
  '';
  # grep '^#!/' -R . | grep -v /nix/store | less
  # (in nix-shell after patchPhase)

  env = {
    SYSTEMC_INCLUDE = "${lib.getDev systemc}/include";
    SYSTEMC_LIBDIR = "${lib.getLib systemc}/lib";
  };

  meta = with lib; {
    description = "Fast and robust (System)Verilog simulator/compiler and linter";
    homepage = "https://www.veripool.org/verilator";
    license = with licenses; [
      lgpl3Only
      artistic2
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [
      thoughtpolice
      amiloradovsky
    ];
  };
}

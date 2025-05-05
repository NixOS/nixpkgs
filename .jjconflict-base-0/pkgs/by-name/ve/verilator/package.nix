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
  gdb,
}:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "5.034";

  # Verilator gets the version from this environment variable
  # if it can't do git describe while building.
  VERILATOR_SRC_VERSION = "v${version}";

  src = fetchFromGitHub {
    owner = "verilator";
    repo = "verilator";
    rev = "v${version}";
    hash = "sha256-1o9Qf6avdiRgIYUgBS/S0W2GLSi/HdO9Xgs78oW6VJE=";
  };

  enableParallelBuilding = true;
  buildInputs = [
    perl
    python3
    systemc
    # ccache
  ];
  nativeBuildInputs =
    [
      makeWrapper
      flex
      bison
      autoconf
      help2man
      git
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      gdb
    ];

  nativeCheckInputs =
    [
      which
      coreutils
      # cmake
      python3
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      numactl
    ];

  doCheck = true;
  checkTarget = "test";

  preConfigure = "autoconf";

  postPatch = ''
    patchShebangs bin/* src/* nodist/* docs/bin/* examples/xml_py/* \
    test_regress/{driver.py,t/*.{pl,pf}} \
    test_regress/t/t_a1_first_cc.py \
    test_regress/t/t_a2_first_sc.py \
    ci/* ci/docker/run/* ci/docker/run/hooks/* ci/docker/buildenv/build.sh
    # verilator --gdbbt uses /bin/echo to test if gdb works.
    substituteInPlace bin/verilator --replace-fail "/bin/echo" "${coreutils}/bin/echo"
  '';
  # grep '^#!/' -R . | grep -v /nix/store | less
  # (in nix-shell after patchPhase)

  # This is needed to ensure that the check phase can find the verilator_bin_dbg.
  preCheck = ''
    export PATH=$PWD/bin:$PATH
  '';

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

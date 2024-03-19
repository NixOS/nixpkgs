{ lib, stdenv, fetchFromGitHub, fetchpatch, perl, flex, bison, python3, autoconf,
  which, cmake, ccache, help2man, makeWrapper, glibcLocales,
  systemc, git, numactl }:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "5.022";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ya3lqK8BfvMVLZUrD2Et6OmptteWXp5VmZb2x2G/V/E=";
  };

  patches = [
    (fetchpatch {
      # Fix try-lock spuriously fail in V3ThreadPool destructor
      # https://github.com/verilator/verilator/pull/4938
      url = "https://github.com/verilator/verilator/commit/4b9cce4369c78423779238e585ed693c456d464e.patch";
      hash = "sha256-sGrk/pxqZqUcmJdzQoPlzXMmYqHCOmd9Y2n6ieVNg1U=";
    })
  ];

  enableParallelBuilding = true;
  buildInputs = [ perl python3 systemc ];  # ccache
  nativeBuildInputs = [ makeWrapper flex bison autoconf help2man git ];
  nativeCheckInputs = [ which numactl ];  # cmake

  doCheck = stdenv.isLinux; # darwin tests are broken for now...
  checkTarget = "test";

  preConfigure = "autoconf";

  postPatch = ''
    patchShebangs bin/* src/* nodist/* docs/bin/* examples/xml_py/* \
    test_regress/{driver.pl,t/*.{pl,pf}} \
    ci/* ci/docker/run/* ci/docker/run/hooks/* ci/docker/buildenv/build.sh
  '';
  # grep '^#!/' -R . | grep -v /nix/store | less
  # (in nix-shell after patchPhase)

  postInstall = lib.optionalString stdenv.isLinux ''
    for x in $(ls $out/bin/verilator*); do
      wrapProgram "$x" --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive"
    done
  '';

  env = {
    SYSTEMC_INCLUDE = "${lib.getDev systemc}/include";
    SYSTEMC_LIBDIR = "${lib.getLib systemc}/lib";
  };

  meta = with lib; {
    description = "Fast and robust (System)Verilog simulator/compiler and linter";
    homepage    = "https://www.veripool.org/verilator";
    license     = with licenses; [ lgpl3Only artistic2 ];
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice amiloradovsky ];
  };
}

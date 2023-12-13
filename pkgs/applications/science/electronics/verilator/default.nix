{ lib, stdenv, fetchFromGitHub, perl, flex, bison, python3, autoconf,
  which, cmake, ccache, help2man, makeWrapper, glibcLocales,
  systemc, git, numactl }:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "5.018";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f06UzNw2MQ5me03EPrVFhkwxKum/GLDzQbDNTBsJMJs=";
  };

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

  meta = with lib; {
    description = "Fast and robust (System)Verilog simulator/compiler and linter";
    homepage    = "https://www.veripool.org/verilator";
    license     = with licenses; [ lgpl3Only artistic2 ];
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice amiloradovsky ];
  };
}

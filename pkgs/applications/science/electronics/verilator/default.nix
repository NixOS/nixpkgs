<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, perl, flex, bison, python3, autoconf,
  which, cmake, ccache, help2man, makeWrapper, glibcLocales,
  systemc, git, numactl }:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "5.012";
=======
{ lib, stdenv, fetchFromGitHub
, perl, flex, bison, python3, autoconf
, which, cmake, help2man
, makeWrapper, glibcLocales
}:

stdenv.mkDerivation rec {
  pname = "verilator";
  version = "5.010";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Y6GkIgkauayJmGhOQg2kWjbcxYVIob6InMopv555Lb8=";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl python3 systemc ];  # ccache
  nativeBuildInputs = [ makeWrapper flex bison autoconf help2man git ];
  nativeCheckInputs = [ which numactl ];  # cmake
=======
    hash = "sha256-NaWatK4sAc+MJolbQs4TDaD9TvY6VAj/KVZBkIq++sQ=";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl ];
  nativeBuildInputs = [ makeWrapper flex bison python3 autoconf help2man ];
  nativeCheckInputs = [ which ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = stdenv.isLinux; # darwin tests are broken for now...
  checkTarget = "test";

  preConfigure = "autoconf";

  postPatch = ''
<<<<<<< HEAD
    patchShebangs bin/* src/* nodist/* docs/bin/* examples/xml_py/* \
    test_regress/{driver.pl,t/*.{pl,pf}} \
    ci/* ci/docker/run/* ci/docker/run/hooks/* ci/docker/buildenv/build.sh
  '';
  # grep '^#!/' -R . | grep -v /nix/store | less
  # (in nix-shell after patchPhase)
=======
    patchShebangs bin/* src/{flexfix,vlcovgen} test_regress/{driver.pl,t/*.pl}
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = lib.optionalString stdenv.isLinux ''
    for x in $(ls $out/bin/verilator*); do
      wrapProgram "$x" --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive"
    done
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "Fast and robust (System)Verilog simulator/compiler and linter";
    homepage    = "https://www.veripool.org/verilator";
    license     = with licenses; [ lgpl3Only artistic2 ];
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice amiloradovsky ];
=======
    description = "Fast and robust (System)Verilog simulator/compiler";
    homepage    = "https://www.veripool.org/wiki/verilator";
    license     = with licenses; [ lgpl3Only artistic2 ];
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

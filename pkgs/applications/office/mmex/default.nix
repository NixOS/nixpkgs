# To use this program, copy all that is in $out/opt/mmax into a writable directory,
# and run it from there. This is the intended usage, as far as I understand.

{ fetchsvn, stdenv, wxGTK }:

let version = "0.9.5.1";
in
  stdenv.mkDerivation {
    name = "money-manager-ex-${version}";

    src = fetchsvn {
      url = "https://moneymanagerex.svn.sourceforge.net/svnroot/moneymanagerex/tags/releases/${version}";
      sha256 = "0mby1p01fyxk5pgd7h3919q91r10zbfk16rfz1kbchqxqz87x4jq";
    };

    preConfigure = ''
      export CFLAGS="-I`pwd`/include"
      export CXXFLAGS="$CFLAGS"
    '';

    installPhase = ''
      ensureDir $out/opt/mmex
      cp -r mmex runtime/{*.txt,*.png,*.db3,en,help,*.wav,*.ico} $out/opt/mmex
    '';

    buildInputs = [ wxGTK ];

    meta = {
      description = "Easy-to-use personal finance software";
      homepage = http://www.codelathe.com/mmex;
      license = "GPLv2+";
      maintainers = with stdenv.lib.maintainers; [viric];
      platforms = with stdenv.lib.platforms; linux;
    };
  }

{ stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  name = "skim-${version}";
  version = "1.4.28";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/skim-app/Skim/Skim-${version}/Skim-${version}.dmg";
    sha256 = "1ip54gyd6aizmgvmhdclhfs0sr42kskhl4ivky4xyp9gq89p4fzw";
  };

  buildInputs = [ undmg ];

  installPhase = ''
    local app=$out/Applications/Skim.app

    mkdir -p $app
    cp -R . $app
    chmod a+x $app/Contents/MacOS/Skim
  '';

  meta = with stdenv.lib; {
    description = "PDF reader and note-taker for OS X";
    homepage = "http://skim-app.sourceforge.net";
    repositories.svn = "https://svn.code.sf.net/p/skim-app/code/trunk";

    license = licenses.bsd2;

    platforms = platforms.darwin;
    maintainers = with maintainers; [ yurrriq ];
  };
}

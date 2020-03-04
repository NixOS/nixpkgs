{ fetchurl, stdenv, trivialBuild }:

trivialBuild {
  pname = "sv-kalender";
  version = "1.9";

  src = fetchurl {
    url = "http://bigwalter.net/daniel/elisp/sv-kalender.el";
    sha256 = "0kilp0nyhj67qscy13s0g07kygz2qwmddklhan020sk7z7jv3lpi";
    postFetch = ''
      echo "(provide 'sv-kalender)" >> $out
    '';
  };

  meta = with stdenv.lib; {
    description = "Swedish calendar for Emacs";
    homepage = "http://bigwalter.net/daniel/elisp/sv-kalender.el";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = [ maintainer.rycee ];
  };
}

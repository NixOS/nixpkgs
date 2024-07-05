{ fetchurl, lib, trivialBuild }:

trivialBuild {
  pname = "sv-kalender";
  version = "1.11";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/emacsmirror/emacswiki.org/ec4fa36bdba5d2c5c4f5e0400a70768c10e969e8/sv-kalender.el";
    sha256 = "0mcx7g1pg6kfp0i4b9rh3q9csgdf3054ijswy368bxwdxsjgfz2m";
  };

  meta = with lib; {
    description = "Swedish calendar for Emacs";
    homepage = "https://www.emacswiki.org/emacs/sv-kalender.el";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.rycee ];
  };
}

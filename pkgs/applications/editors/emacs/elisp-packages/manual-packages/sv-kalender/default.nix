{ fetchurl, lib, trivialBuild }:

trivialBuild {
  pname = "sv-kalender";
  version = "1.11";

  src = fetchurl {
    url = "http://bigwalter.net/daniel/elisp/sv-kalender.el";
    sha256 = "0mcx7g1pg6kfp0i4b9rh3q9csgdf3054ijswy368bxwdxsjgfz2m";
  };

  meta = with lib; {
    description = "Swedish calendar for Emacs";
    homepage = "http://bigwalter.net/daniel/elisp/sv-kalender.el";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.rycee ];
  };
}

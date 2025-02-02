{ lib, fetchurl, trivialBuild }:

trivialBuild {
  pname = "yes-no";
  version = "0-unstable-2017-10-01";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/emacsmirror/emacswiki.org/143bcaeb679a8fa8a548e92a5a9d5c2baff50d9c/yes-no.el";
    sha256 = "03w4wfx885y89ckyd5d95n2571nmmzrll6kr0yan3ip2aw28xq3i";
  };

  meta = with lib; {
    description = "Specify use of `y-or-n-p' or `yes-or-no-p' on a case-by-case basis";
    homepage = "https://www.emacswiki.org/emacs/yes-no.el";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jcs090218 ];
    platforms = platforms.all;
  };
}

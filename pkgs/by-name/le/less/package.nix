{ lib
, stdenv
, fetchurl
, ncurses
, pcre2
, withSecure ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "less";
  version = "668";

  # Only tarballs on the website are valid releases,
  # other versions, e.g. git tags are considered snapshots.
  src = fetchurl {
    url = "https://www.greenwoodsoftware.com/less/less-${finalAttrs.version}.tar.gz";
    hash = "sha256-KBn1VWTYbVQqu+yv2C/2HoGaPuyWf6o2zT5o8VlqRLg=";
  };

  buildInputs = [
    ncurses
    pcre2
  ];

  outputs = [ "out" "man" ];

  configureFlags = [
    # Look for 'sysless' in /etc.
    "--sysconfdir=/etc"
    "--with-regex=pcre2"
  ] ++ lib.optional withSecure "--with-secure";

  meta = {
    homepage = "https://www.greenwoodsoftware.com/less/";
    description = "More advanced file pager than 'more'";
    changelog = "https://www.greenwoodsoftware.com/less/news.${finalAttrs.version}.html";
    license = lib.licenses.gpl3Plus;
    mainProgram = "less";
    maintainers = with lib.maintainers; [ dtzWill ];
    platforms = lib.platforms.unix;
  };
})

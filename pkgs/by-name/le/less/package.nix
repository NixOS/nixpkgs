{ lib
, stdenv
, fetchurl
, ncurses
, pcre2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "less";
  version = "643";

  # Only tarballs on the website are valid releases,
  # other versions, e.g. git tags are considered snapshots.
  src = fetchurl {
    url = "https://www.greenwoodsoftware.com/less/less-${finalAttrs.version}.tar.gz";
    hash = "sha256-KRG1QyyDb6CEyKLmj2zWMSNywCalj6qpiGJzHItgUug=";
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
  ];

  meta = {
    homepage = "https://www.greenwoodsoftware.com/less/";
    description = "A more advanced file pager than 'more'";
    changelog = "https://www.greenwoodsoftware.com/less/news.${finalAttrs.version}.html";
    license = lib.licenses.gpl3Plus;
    mainProgram = "less";
    maintainers = with lib.maintainers; [ eelco dtzWill ];
    platforms = lib.platforms.unix;
  };
})

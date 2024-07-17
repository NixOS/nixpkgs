{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses,
  pcre2,
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

  patches = [
    (fetchpatch {
      # https://www.openwall.com/lists/oss-security/2024/04/12/5
      name = "sec-issue-newline-path.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/less/-/raw/1d570db0c84fe95799f460526492e45e24c30ad0/backport-007521ac3c95bc76.patch";
      hash = "sha256-BT8DLIu7oVhL5XL50uFVUp97qjklcvRHy85UQwVKAmc=";
    })
  ];

  buildInputs = [
    ncurses
    pcre2
  ];

  outputs = [
    "out"
    "man"
  ];

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
    maintainers = with lib.maintainers; [
      eelco
      dtzWill
    ];
    platforms = lib.platforms.unix;
  };
})

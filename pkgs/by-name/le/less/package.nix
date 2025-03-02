{
  lib,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  ncurses,
  pcre2,
  stdenv,
  # Boolean options
  withSecure ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "less";
  version = "668";

  # `less` is provided by the following sources:
  # - meta.homepage
  # - GitHub: https://github.com/gwsw/less/
  # The releases recommended for general consumption are only those from
  # homepage, and only those not marked as beta.
  src = fetchurl {
    url = "https://www.greenwoodsoftware.com/less/less-${finalAttrs.version}.tar.gz";
    hash = "sha256-KBn1VWTYbVQqu+yv2C/2HoGaPuyWf6o2zT5o8VlqRLg=";
  };

  patches = [
    (fetchpatch {
      # Fix configure parameters --with-secure=no and --without-secure.
      url = "https://github.com/gwsw/less/commit/8fff6c56bfc833528b31ebdaee871f65fbe342b1.patch";
      hash = "sha256-XV5XufivNWWLGeIpaP04YQPWcxIUKYYEINdT+eEx+WA=";
      includes = [
        "configure.ac"
      ];
    })
  ];

  # Need `autoreconfHook` since we patch `configure.ac`.
  # TODO: Remove the `configure.ac` patch and `autoreconfHook` next release
  nativeBuildInputs = [
    autoreconfHook
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
    "--sysconfdir=/etc" # Look for 'sysless' in /etc
    (lib.withFeatureAs true "regex" "pcre2")
    (lib.withFeature withSecure "secure")
  ];

  strictDeps = true;

  meta = {
    homepage = "https://www.greenwoodsoftware.com/less/";
    description = "More advanced file pager than 'more'";
    changelog = "https://www.greenwoodsoftware.com/less/news.${finalAttrs.version}.html";
    license = lib.licenses.gpl3Plus;
    mainProgram = "less";
    maintainers = with lib.maintainers; [
      # not active
      dtzWill
    ];
    platforms = lib.platforms.unix;
  };
})

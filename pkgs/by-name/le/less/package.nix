{
  lib,
  fetchurl,
  ncurses,
  pcre2,
  stdenv,
  versionCheckHook,
  # Boolean options
  withSecure ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "less";
  version = "685";

  # `less` is provided by the following sources:
  # - meta.homepage
  # - GitHub: https://github.com/gwsw/less/
  # The releases recommended for general consumption are only those from
  # homepage, and only those not marked as beta.
  src = fetchurl {
    url = "https://www.greenwoodsoftware.com/less/less-${finalAttrs.version}.tar.gz";
    hash = "sha256-JwEEHnZ+aX7kIM4IJWQc7cjyC1FXar6Z2SwWZtMy6dw=";
  };

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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    homepage = "https://www.greenwoodsoftware.com/less/";
    description = "More advanced file pager than 'more'";
    changelog = "https://www.greenwoodsoftware.com/less/news.${finalAttrs.version}.html";
    license = lib.licenses.gpl3Plus;
    mainProgram = "less";
    maintainers = with lib.maintainers; [
      mdaniels5757
      yiyu
    ];
    platforms = lib.platforms.unix;
  };
})

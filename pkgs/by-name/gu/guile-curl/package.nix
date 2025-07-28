{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  guile,
  pkg-config,
  texinfo,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-curl";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "spk121";
    repo = "guile-curl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nVA0cl4Oog3G+Ww0n0QMxJ66iqTn4VxrV+sqd6ACWl4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];

  buildInputs = [
    guile
    curl
  ];

  # error: possibly undefined macro: AC_LIB_LINKFLAGS_FROM_LIBS
  preAutoreconf = ''
    cp ${gettext}/share/gettext/m4/lib-{ld,link,prefix}.m4 m4
  '';

  meta = {
    description = "Bindings to cURL for GNU Guile";
    homepage = "https://github.com/spk121/guile-curl";
    changelog = "https://github.com/spk121/guile-curl/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = guile.meta.platforms;
  };
})

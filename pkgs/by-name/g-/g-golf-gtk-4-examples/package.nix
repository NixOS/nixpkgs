{
  stdenv,
  lib,
  makeWrapper,
  wrapGAppsHook4,
  pkg-config,
  guile,
  guile-cairo,
  glib,
  gobject-introspection,
  gtk4,
  which,
  adwaita-icon-theme,
  libadwaita,
  g-golf,
  texinfo,
  g-golf-adw-1-examples,
  useLibadwaita ? false,
}:
stdenv.mkDerivation (finalAttrs: {

  inherit (g-golf) version src;

  pname = "g-golf-${finalAttrs.variant}-examples";

  variant = if useLibadwaita then "adw-1" else "gtk-4";

  nativeBuildInputs = [
    pkg-config
    which
    texinfo
    makeWrapper
    wrapGAppsHook4
    glib
  ] ++ lib.optionals useLibadwaita [ libadwaita ];

  buildInputs = [
    guile
    g-golf
    guile-cairo
    gobject-introspection
    gtk4
    adwaita-icon-theme
  ];

  sourceRoot = "g-golf-${finalAttrs.version}/examples/${finalAttrs.variant}/${
    if useLibadwaita then "demo" else "demos"
  }";

  postBuild =
    if useLibadwaita then "glib-compile-resources --target g-resources g-resources.xml" else "";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/doc/g-golf/examples
    cp -rf .. $out/share/doc/g-golf/examples/

    find $out/share -type f -executable | while read file; do
      name=g-golf-${finalAttrs.variant}-$(basename $file)
      makeWrapper $file $out/bin/$name \
        --chdir $(dirname $file) \
        --prefix PATH : "${guile}/bin" \
        --prefix GUILE_LOAD_PATH : "$GUILE_LOAD_PATH" \
        --prefix GUILE_LOAD_COMPILED_PATH : "$GUILE_LOAD_COMPILED_PATH" \
        --prefix LD_LIBRARY_PATH : "${g-golf}/lib:${guile-cairo}/lib" \
        --set GUILE_AUTO_COMPILE 0
    done

    runHook postInstall
  '';

  passthru.tests = { inherit g-golf-adw-1-examples; };

  meta = {
    description = "G-Golf ${finalAttrs.variant} examples";
    homepage = "https://www.gnu.org/software/g-golf/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ mobid ];
    platforms = lib.platforms.unix;
  };
})

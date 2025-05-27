{
  stdenv,
  lib,
  fetchurl,
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
  callPackage,
  g-golf,
  texinfo,
}:
stdenv.mkDerivation (finalAttrs: {

  inherit (g-golf) version src;

  pname = "g-golf-gtk-4-examples";

  nativeBuildInputs = [
    pkg-config
    which
    texinfo
    makeWrapper
    wrapGAppsHook4
    glib
  ];

  buildInputs = [
    guile
    g-golf
    guile-cairo
    gobject-introspection
    gtk4
    adwaita-icon-theme
  ];

  sourceRoot = "g-golf-${finalAttrs.version}/examples/gtk-4/demos";

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/g-golf/examples
    cp -rf .. $out/share/doc/g-golf/examples/

    find $out/share -type f -executable | while read file; do
      name=g-golf-gtk-4-$(basename $file)
      makeWrapper $file $out/bin/$name \
        --chdir $(dirname $file) \
        --prefix PATH : "${guile}/bin" \
        --prefix GUILE_LOAD_PATH : "$GUILE_LOAD_PATH" \
        --prefix GUILE_LOAD_COMPILED_PATH : "$GUILE_LOAD_COMPILED_PATH" \
        --prefix LD_LIBRARY_PATH : "${g-golf}/lib:${guile-cairo}/lib" \
        --set GUILE_AUTO_COMPILE 0
    done
  '';

  meta = {
    description = "G-Golf gtk-4 examples";
    homepage = "https://www.gnu.org/software/g-golf/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ mobid ];
    platforms = lib.platforms.unix;
  };
})

source $stdenv/setup

preConfigure() {
  for pot in `awk -F '=' '/POTFILES=/{print $2}' translations/Makefile`; do
    echo ${pot##../}
  done > translations/POTFILES.in
  cat translations/POTFILES.in
  sed -i -e "/xgettext/d" translations/Makefile
  sed -i -e "/template.pot:/a\\\tintltool-update --gettext-package=\$(PACKAGENAME) -o \$@ sv" translations/Makefile
}

postUnpack() {
  mkdir -p $out/lib/mozilla/plugins
}

installPhase() {
  cp -p plugin/libfribidplugin.so $out/lib/mozilla/plugins
}

genericBuild


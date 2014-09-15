{ pkgs, stdenv, fetchurl, python, buildPythonPackage, pythonPackages, mygpoclient, intltool,
  ipodSupport ? true, libgpod, gpodderHome ? "", gpodderDownloadDir ? "",
  gnome3, hicolor_icon_theme }:

with pkgs.lib;

let
  inherit (pythonPackages) coverage feedparser minimock sqlite3 dbus pygtk eyeD3;

in buildPythonPackage rec {
  name = "gpodder-3.8.0";

  src = fetchurl {
    url = "http://gpodder.org/src/${name}.tar.gz";
    sha256 = "0731f08f4270c81872b841b55200ae80feb4502706397d0085079471fb9a8fe4";
  };

  buildInputs = [
    coverage feedparser minimock sqlite3 mygpoclient intltool
    gnome3.gnome_icon_theme gnome3.gnome_icon_theme_symbolic
    hicolor_icon_theme
  ];

  propagatedBuildInputs = [ feedparser dbus mygpoclient sqlite3 pygtk eyeD3 ]
    ++ stdenv.lib.optional ipodSupport libgpod;

  postPatch = "sed -ie 's/PYTHONPATH=src/PYTHONPATH=\$(PYTHONPATH):src/' makefile";

  checkPhase = "make unittest";

  preFixup = ''
    wrapProgram $out/bin/gpodder \
      ${optionalString (gpodderHome != "") "--set GPODDER_HOME ${gpodderHome}"} \
      ${optionalString (gpodderDownloadDir != "") "--set GPODDER_DOWNLOAD_DIR ${gpodderDownloadDir}"} \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  # The `wrapPythonPrograms` script in the postFixup phase breaks gpodder. The
  # easiest way to fix this is to call wrapPythonPrograms and then to clean up
  # the wrapped file.
  postFixup = ''
    wrapPythonPrograms

    if test -e $out/nix-support/propagated-build-inputs; then
        ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    fi

    createBuildInputsPth build-inputs "$buildInputStrings"
    for inputsfile in propagated-build-inputs propagated-native-build-inputs; do
      if test -e $out/nix-support/$inputsfile; then
          createBuildInputsPth $inputsfile "$(cat $out/nix-support/$inputsfile)"
      fi
    done

    sed -i "$out/bin/..gpodder-wrapped-wrapped" -e '{
        /import sys; sys.argv/d
    }'
  '';

  installPhase = "DESTDIR=/ PREFIX=$out make install";

  meta = {
    description = "A podcatcher written in python";
    longDescription = ''
      gPodder downloads and manages free audio and video content (podcasts)
      for you. Listen directly on your computer or on your mobile devices.
    '';
    homepage = "http://gpodder.org/";
    license = "GPLv3";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.skeidel ];
  };
}

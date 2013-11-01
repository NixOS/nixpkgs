{ stdenv, fetchurl, python, buildPythonPackage, pythonPackages, pkgconfig
, pyrex096, ffmpeg, boost, glib, pygobject, gtk2, webkit_gtk2, libsoup, pygtk
, taglib, pysqlite, pycurl, mutagen, pycairo, pythonDBus, pywebkitgtk
, libtorrentRasterbar
, gst_python, gst_plugins_base, gst_plugins_good, gst_ffmpeg
}:

buildPythonPackage rec {
  name = "miro-${version}";
  namePrefix = "";
  version = "6.0";

  src = fetchurl {
    url = "http://ftp.osuosl.org/pub/pculture.org/miro/src/${name}.tar.gz";
    sha256 = "0sq25w365i1fz95398vxql3yjl5i6mq77mnmlhmn0pgyg111k3am";
  };

  setSourceRoot = ''
    sourceRoot=${name}/linux
  '';

  patches = [ ./gconf.patch ];

  postPatch = ''
    sed -i -e '2i import os; os.environ["GST_PLUGIN_PATH"] = \\\
      '"'$GST_PLUGIN_PATH'" miro.real

    sed -i -e 's/\$(shell which python)/python/' Makefile
    sed -i -e 's|/usr/bin/||' -e 's|/usr||' \
           -e 's/BUILD_TIME[^,]*/BUILD_TIME=0/' setup.py

    sed -i -e 's|default="/usr/bin/ffmpeg"|default="${ffmpeg}/bin/ffmpeg"|' \
      plat/options.py

    sed -i -e 's|/usr/share/miro/themes|'"$out/share/miro/themes"'|' \
           -e 's/gnome-open/xdg-open/g' \
           -e '/RESOURCE_ROOT =.*(/,/)/ {
                 c RESOURCE_ROOT = '"'$out/share/miro/resources/'"'
               }' \
           plat/resources.py
  '';

  installCommand = ''
    python setup.py install --prefix= --root="$out"
  '';

  # Disabled for now, because it requires networking and even if we skip those
  # tests, the whole test run takes around 10-20 minutes.
  doCheck = false;
  checkPhase = ''
    HOME="$TEMPDIR" LANG=en_US.UTF-8 python miro.real --unittest
  '';

  postInstall = ''
    mv "$out/bin/miro.real" "$out/bin/miro"
  '';

  buildInputs = [
    pkgconfig pyrex096 ffmpeg boost glib pygobject gtk2 webkit_gtk2 libsoup
    pygtk taglib
  ];

  propagatedBuildInputs = [
    pygobject pygtk pycurl python.modules.sqlite3 mutagen pycairo pythonDBus
    pywebkitgtk libtorrentRasterbar
    gst_python gst_plugins_base gst_plugins_good gst_ffmpeg
  ];

  meta = {
    homepage = "http://www.getmiro.com/";
    description = "Video and audio feed aggregator";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
    platforms = stdenv.lib.platforms.linux;
  };
}

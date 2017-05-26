{ stdenv, fetchurl, pkgconfig
, pythonPackages, pyrex096, ffmpeg, boost, glib, gtk2, webkitgtk24x-gtk2, libsoup
, taglib, sqlite
, libtorrentRasterbar, glib_networking, gsettings_desktop_schemas
, gst-python, gst-plugins-base, gst-plugins-good, gst-ffmpeg
, enableBonjour ? false, avahi ? null
}:

assert enableBonjour -> avahi != null;

with stdenv.lib;

let
  inherit (pythonPackages) python buildPythonApplication;
  version = "6.0";
in buildPythonApplication rec {
  name = "miro-${version}";

  src = fetchurl {
    url = "http://ftp.osuosl.org/pub/pculture.org/miro/src/${name}.tar.gz";
    sha256 = "0sq25w365i1fz95398vxql3yjl5i6mq77mnmlhmn0pgyg111k3am";
  };

  setSourceRoot = ''
    sourceRoot=${name}/linux
  '';

  patches = [ ./gconf.patch ];

  postPatch = ''
    patch -p1 -d .. < "${./youtube-feeds.patch}"

    sed -i -e 's/\$(shell which python)/python/' Makefile
    sed -i -e 's|/usr/bin/||' -e 's|/usr||' \
           -e 's/BUILD_TIME[^,]*/BUILD_TIME=0/' setup.py

    sed -i -e 's|default="/usr/bin/ffmpeg"|default="${ffmpeg.bin}/bin/ffmpeg"|' \
      plat/options.py

    sed -i -e 's|/usr/share/miro/themes|'"$out/share/miro/themes"'|' \
           -e 's/gnome-open/xdg-open/g' \
           -e '/RESOURCE_ROOT =.*(/,/)/ {
                 c RESOURCE_ROOT = '"'$out/share/miro/resources/'"'
               }' \
           plat/resources.py
  '' + optionalString enableBonjour ''
    sed -i -e 's|ctypes.cdll.LoadLibrary( *|ctypes.CDLL("${avahi}/lib/" +|' \
      ../lib/libdaap/pybonjour.py
  '';

  # Disabled for now, because it requires networking and even if we skip those
  # tests, the whole test run takes around 10-20 minutes.
  doCheck = false;
  checkPhase = ''
    HOME="$TEMPDIR" LANG=en_US.UTF-8 python miro.real --unittest
  '';

  preInstall = ''
    # see https://bitbucket.org/pypa/setuptools/issue/130/install_data-doesnt-respect-prefix
    ${python.interpreter} setup.py install_data --root=$out
    sed -i '/data_files=data_files/d' setup.py
  '';

  postInstall = ''
    mv "$out/bin/miro.real" "$out/bin/miro"
    wrapProgram "$out/bin/miro" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking.out}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
  '';

  buildInputs = with pythonPackages; [ pygtk pygobject2 ] ++ [
    pkgconfig pyrex096 ffmpeg boost glib gtk2 webkitgtk24x-gtk2 libsoup
    taglib gsettings_desktop_schemas sqlite
  ];

  propagatedBuildInputs = with pythonPackages; [
    pygobject2 pygtk pycurl mutagen pycairo dbus-python
    pywebkitgtk] ++ [ libtorrentRasterbar
    gst-python gst-plugins-base gst-plugins-good gst-ffmpeg
  ] ++ optional enableBonjour avahi;

  meta = {
    homepage = "http://www.getmiro.com/";
    description = "Video and audio feed aggregator";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.aszlig ];
    platforms = platforms.linux;
  };
}

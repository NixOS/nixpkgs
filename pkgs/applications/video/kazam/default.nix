{ stdenv, fetchurl, python3Packages, gst_all_1, makeWrapper, gobjectIntrospection
, gtk3, libwnck3, keybinder, intltool, libcanberra }:


python3Packages.buildPythonApplication rec {
  name = "kazam-${version}";
  version = "1.4.3";
  namePrefix = "";

  src = fetchurl {
    url = "https://launchpad.net/kazam/stable/${version}/+download/kazam-${version}.tar.gz";
    sha256 = "00bcn0yj9xrv87sf6xd3wpilsjgjpsj15zzpjh351ffpjnr0ica8";
  };

  # TODO: keybinder, appindicator3
  buildInputs = with python3Packages;
    [ pygobject3 pyxdg pycairo gst_all_1.gstreamer gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good gobjectIntrospection gtk3 libwnck3 distutils_extra
      intltool dbus ];

  # TODO: figure out why PYTHONPATH is not passed automatically for those programs
  pythonPath = with python3Packages;
    [ pygobject3 pyxdg pycairo dbus ];

  patches = [ ./datadir.patch ./bug_1190693.patch ];
  prePatch = ''
    rm setup.cfg
    substituteInPlace kazam/backend/grabber.py --replace "/usr/bin/canberra-gtk-play" "${libcanberra}/bin/canberra-gtk-play"
  '';

  # no tests
  doCheck = false;

  preFixup = ''
    wrapProgram $out/bin/kazam \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix LD_LIBRARY_PATH ":" "${gtk3.out}/lib:${gst_all_1.gstreamer}/lib:${keybinder}/lib" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH" \
      --prefix XDG_DATA_DIRS : "${gtk3.out}/share" \
      --set GST_REGISTRY "/tmp/kazam.gstreamer.registry";
  '';


  meta = with stdenv.lib; {
    description = "Cross-platform, Friend-2-Friend and secure decentralised communication platform";
    homepage = https://code.launchpad.net/kazam;
    #license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
  };
}

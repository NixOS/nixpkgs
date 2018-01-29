{ stdenv, fetchFromGitHub, pythonPackages, libnotify, syncthing, librsvg
, gobjectIntrospection, psmisc, gtk3
}:

pythonPackages.buildPythonApplication rec {
  version = "0.9.2.3";
  name = "syncthing-gtk-${version}";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing-gtk";
    rev = "v${version}";
    sha256 = "0chl0f0kp6z0z00d1f3xjlicjfr9rzabw39wmjr66fwb5w5hcc42";
  };

  propagatedBuildInputs = [
    libnotify syncthing gobjectIntrospection psmisc gtk3
    (librsvg.override { enableIntrospection = true; })
  ] ++ (with pythonPackages; [ dateutil pyinotify pygobject3 ]);

  preFixup = ''
    wrapProgram $out/bin/syncthing-gtk \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
  '';

  patchPhase = ''
    substituteInPlace setup.py --replace "version = get_version()" "version = '${version}'"
    substituteInPlace scripts/syncthing-gtk --replace "/usr/share" "$out/share"
    substituteInPlace syncthing_gtk/app.py --replace "/usr/share" "$out/share"
    substituteInPlace syncthing_gtk/wizard.py --replace "/usr/share" "$out/share"
    substituteInPlace syncthing-gtk.desktop --replace "/usr/bin/syncthing-gtk" "$out/bin/syncthing-gtk"
  '';

  meta = with stdenv.lib; {
    description = " GTK3 & python based GUI for Syncthing ";
    maintainers = with maintainers; [ ];
    platforms = syncthing.meta.platforms;
    homepage = "https://github.com/syncthing/syncthing-gtk";
    license = licenses.gpl2;
  };
}

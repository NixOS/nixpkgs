{ stdenv, fetchFromGitHub, libnotify, librsvg, psmisc, gtk3, syncthing, python2Packages }:

python2Packages.buildPythonApplication rec {
  version = "0.9.2.3";
  name = "syncthing-gtk-${version}";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing-gtk";
    rev = "v${version}";
    sha256 = "0chl0f0kp6z0z00d1f3xjlicjfr9rzabw39wmjr66fwb5w5hcc42";
  };

  propagatedBuildInputs = with python2Packages; [
    syncthing dateutil pyinotify libnotify
    (librsvg.override { withGTK = true; })
    psmisc pygobject3 gtk3
  ];

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

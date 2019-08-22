{ stdenv, lib, fetchgit, intltool, python3Packages
, libtorrentRasterbar
, withGui ? true, gobject-introspection ? null, gtk3 ? null
, libappindicator-gtk3 ? null, librsvg ? null, libnotify ? null, wrapGAppsHook ? null
}:

python3Packages.buildPythonApplication rec {
  pname = "deluge";
  version = "2.0.3";

  src = fetchgit {
    url = "https://git.deluge-torrent.org/deluge/";
    sha256 = "0zav045bp3z3hrp6jni6wr9ryihgf1ngvgrn9vgbbwrhgdf3d3yg";
    rev = "deluge-${version}";
  };

  postPatch = ''
    echo ${version} > RELEASE-VERSION
  '';

  buildInputs = lib.optionals withGui [ gobject-introspection gtk3 libnotify librsvg ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python geoip2 pillow rencode setproctitle six
    twisted Mako chardet pyxdg pyopenssl service-identity
    (libtorrentRasterbar.override { inherit (python3Packages) python; }).python
  ] ++ lib.optionals withGui [ distro libappindicator-gtk3 pycairo pygobject3 ];

  nativeBuildInputs = [ intltool ]
    ++ lib.optional withGui wrapGAppsHook
    ++ [ python3Packages.slimit ];

  # there are tests but we don't have the prereqs in nixpkgs
  doCheck = false;

  postInstall = ''
     install -Dm644 -t $out/share/applications deluge/ui/data/share/applications/deluge.desktop
     install -Dm444 -t $out/lib/systemd/user   packaging/systemd/*.service
     cp -R deluge/ui/data/{icons,pixmaps} $out/share/
  '';

  meta = with stdenv.lib; {
    description = "Torrent client";
    homepage = "https://deluge-torrent.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ domenkozar ebzzry ];
    platforms = platforms.all;
  };
}

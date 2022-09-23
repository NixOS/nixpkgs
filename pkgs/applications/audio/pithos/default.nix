{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, appstream-glib
, wrapGAppsHook, pythonPackages, gtk3, gnome, gobject-introspection
, libnotify, libsecret, gst_all_1 }:

pythonPackages.buildPythonApplication rec {
  pname = "pithos";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = pname;
    repo  = pname;
    rev = version;
    sha256 = "03j04b1mk2fq0ni2ydpw40fdd36k545z8a1pq9x5c779080cwpla";
  };

  format = "other";

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [ meson ninja pkg-config appstream-glib wrapGAppsHook ];

  propagatedBuildInputs =
    [ gtk3 gobject-introspection libnotify libsecret gnome.adwaita-icon-theme ] ++
    (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad ]) ++
    (with pythonPackages; [ pygobject3 pylast ]);

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Pandora Internet Radio player for GNOME";
    homepage = "https://pithos.github.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ obadz ];
  };
}

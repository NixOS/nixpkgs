{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, appstream-glib
, wrapGAppsHook, pythonPackages, gtk3, gnome, gobject-introspection
, libnotify, libsecret, gst_all_1 }:

pythonPackages.buildPythonApplication rec {
  pname = "pithos";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = pname;
    repo  = pname;
    rev = version;
    hash = "sha256-GPDbFlwiGT/B2paX33d3mUCV77q+fPM0LMaKFsQQjjQ=";
  };

  format = "other";

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [ meson ninja pkg-config appstream-glib wrapGAppsHook ];

  propagatedNativeBuildInputs = [
    gobject-introspection
  ];

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

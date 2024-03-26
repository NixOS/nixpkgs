{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, appstream-glib
, wrapGAppsHook, pythonPackages, gtk3, gnome, gobject-introspection
, libnotify, libsecret, gst_all_1 }:

pythonPackages.buildPythonApplication rec {
  pname = "pithos";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = pname;
    repo  = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-3j6IoMi30BQ8WHK4BxbsW+/3XZx7rBFd47EBENa2GiQ=";
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
    mainProgram = "pithos";
    homepage = "https://pithos.github.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ obadz ];
  };
}

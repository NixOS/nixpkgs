{ lib
, python3
, fetchFromGitHub
, fetchpatch
, appstream-glib
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gst_all_1
, gtk4
, libadwaita
, librsvg
, meson
, ninja
, pkg-config
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mousai";
  version = "0.4.1";

  format = "other";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Mousai";
    rev = "v${version}";
    sha256 = "sha256-AfR5n1dIm9X5OoPiikQEhHBFQq0rmQH4h7cCJ2yXoXI=";
  };

  patches = [
    (fetchpatch {
      name = "fix-ABI-breakage-from-libadwaita.patch";
      url = "https://github.com/SeaDve/Mousai/commit/e3db2d9d1949300f49399209b56d667746e539df.patch";
      sha256 = "078kvmyhw4jd1m2npai0yl00lwh47jys2n03pkgxp6jf873y83vs";
    })
  ];

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gtk4
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtk4
    libadwaita
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    requests
  ];

  meta = with lib; {
    description = "Identify any songs in seconds";
    homepage = "https://github.com/SeaDve/Mousai";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

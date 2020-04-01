{ stdenv, fetchFromGitHub, fetchpatch
, meson, ninja, pkgconfig, desktop-file-utils
, python3, vala, wrapGAppsHook
, evolution-data-server
, libical
, libgee
, json-glib
, glib
, sqlite
, libsoup
, gtk3
, pantheon /* granite, icons, maintainers */
, webkitgtk
}:

stdenv.mkDerivation rec {
  pname = "elementary-planner";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planner";
    rev = version;
    sha256 = "0swj94pqf00wwzsgjap8z19k33gg1wj2b78ba1aj9h791j8lmaim";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    evolution-data-server
    libical
    libgee
    json-glib
    glib
    sqlite
    libsoup
    gtk3
    pantheon.granite
    webkitgtk
    pantheon.elementary-icon-theme
  ];

  # Fix version string, remove in next update!
  patches = [
    (fetchpatch {
      url = "https://github.com/alainm23/planner/pull/194/commits/3d0a2197087b13fe90fa6f85f817ba56798d632c.patch";
      sha256 = "077q5jddi8jaw2ypc6szbd1c50i4x3b21jvmvi3w7g5zhjwpkmf5";
    })
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Task and project manager designed to elementary OS";
    homepage = "https://planner-todo.web.app";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ] ++ pantheon.maintainers;
  };
}


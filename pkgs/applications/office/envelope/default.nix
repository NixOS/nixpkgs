{ stdenv
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkgconfig
, pantheon
, python3
, vala
, appstream-glib
, desktop-file-utils
, gettext
, glib
, gtk3
, libgee
, sqlite
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "envelope";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "cjfloss";
    repo = pname;
    rev = version;
    sha256 = "111lq1gijcm7qwpac09q11ymwiw2x3m12a28ki52f28fb1amvffc";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    meson
    ninja
    vala
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libgee
    pantheon.granite
    sqlite
  ];

  doCheck = true;

  patches = [
    # Fix AppData Validation.
    # https://github.com/cjfloss/envelope/pull/59
    (fetchpatch {
      url = "https://github.com/cjfloss/envelope/commit/b6a28eced89b8f944479fcc695aebfb9aae0c691.patch";
      sha256 = "11znc8z52kl893n3gmmdpnp3y4vpzmb263m5gp0qxbl3xykq2wzr";
    })
  ];

  postPatch = ''
    chmod +x data/post_install.py
    patchShebangs data/post_install.py
  '';

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Personal finance manager for elementary OS";
    homepage = "https://github.com/cjfloss/envelope";
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}

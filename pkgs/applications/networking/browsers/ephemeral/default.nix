{ stdenv
, fetchFromGitHub
, desktop-file-utils
, vala
, gettext
, glib
, gtk3
, libgee
, libdazzle
, meson
, ninja
, pantheon
, pkgconfig
, python3
, webkitgtk
, wrapGAppsHook
, glib-networking
, disableInfobars ? false
}:

stdenv.mkDerivation rec {
  pname = "ephemeral";
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "ephemeral";
    rev = version;
    sha256 = "1lzcwaczh601kwbx7fzg32nrzlg67asby7p86qy10qz86xf4g608";
  };

  patches = stdenv.lib.optionalString disableInfobars [
    ## Disable infobars regarding app not running on ElementaryOS and donation recommendation
    ./disable_paid_and_native_infobars.patch
  ];

  nativeBuildInputs = [
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
    glib-networking
    gtk3
    libdazzle
    libgee
    pantheon.granite
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "The always-incognito web browser";
    homepage = "https://github.com/cassidyjames/ephemeral";
    maintainers = with maintainers; [ xiorcale ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
}

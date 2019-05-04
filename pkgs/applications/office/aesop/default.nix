{ stdenv, fetchFromGitHub, fetchpatch, pantheon, pkgconfig, meson, ninja, python3, gtk3
, desktop-file-utils, json-glib, libsoup, libgee, poppler, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "aesop";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "191azshc2z9pzc61fhmzv5cxnihh5wh3nj803kvi3rnk6nl9mhzh";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkgconfig
    python3
    pantheon.vala
    wrapGAppsHook
  ];

  buildInputs = [
    pantheon.elementary-icon-theme
    libgee
    pantheon.granite
    gtk3
    json-glib
    libsoup
    poppler
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "The simplest PDF viewer around";
    homepage = https://github.com/lainsce/aesop;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}

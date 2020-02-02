{ stdenv, vala, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, python3, gtk3
, desktop-file-utils, json-glib, libsoup, libgee, poppler, wrapGAppsHook, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "aesop";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "1aa1kp1rndi2dj1d9sf8zhssn5dw183yx1fm2xccdy9zjf9wi4jk";
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

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "The simplest PDF viewer around";
    homepage = https://github.com/lainsce/aesop;
    license = licenses.gpl2Plus;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };
}

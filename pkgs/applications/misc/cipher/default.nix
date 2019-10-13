{ stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkgconfig
, pantheon
, python3
, gettext
, glib
, gtk3
, libgee
, xdg_utils
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "cipher";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "arshubham";
    repo = "cipher";
    rev = version;
    sha256 = "0n5aigcyxnl4k52mdmavbxx6afc1ixymn3k3l2ryhyzi5q31x0x3";
  };

  nativeBuildInputs = [
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
    pantheon.granite
    libgee
  ];

  postPatch = ''
  	substituteInPlace data/com.github.arshubham.cipher.desktop.in \
  		--replace xdg-open ${xdg_utils}/bin/xdg-open
    chmod +x post_install.py
    patchShebangs post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A simple application for encoding and decoding text, designed for elementary OS";
    homepage = "https://github.com/arshubham/cipher";
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}

{ stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkgconfig
, pantheon
, python3
, glib
, gtk3
, gtksourceview
, json-glib
, libsoup
, libgee
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "ping";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "jeremyvaartjes";
    repo = "ping";
    rev = version;
    sha256 = "1h9cdy2jxa2ffykjg89j21hazls32z9yyv3g0x07x3vizzl5xcij";
  };

  nativeBuildInputs = [
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
    gtksourceview
    json-glib
    libgee
    libsoup
    pantheon.granite
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
    description = "A helpful tool that lets you debug what part of your API is causing you issues";
    homepage = https://github.com/jeremyvaartjes/ping;
    maintainers = with maintainers; [ kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}

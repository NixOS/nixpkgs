{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, vala
, pkg-config
, pantheon
, python3
, glib
, gtk3
, gtksourceview
, json-glib
, libsoup
, libgee
, wrapGAppsHook
}:

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
    pkg-config
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
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A helpful tool that lets you debug what part of your API is causing you issues";
    homepage = "https://github.com/jeremyvaartjes/ping";
    maintainers = with maintainers; [ xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    license = licenses.gpl3;
    mainProgram = "com.github.jeremyvaartjes.ping";
    # Does not build with vala 0.48 or later
    # ../src/Application.vala:696.46-696.57: error: Assignment: Cannot convert from
    # `GLib.HashTable<weak string,weak string>' to `GLib.HashTable<string,string>?'
    #                     HashTable<string,string> tempDataList = Soup.Form.decode(testObjs[id].data);
    #                                              ^^^^^^^^^^^^
    # Upstream has no activity since 28 Dec 2020
    broken = true;
  };
}

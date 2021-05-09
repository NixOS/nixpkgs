{ lib
, stdenv
, fetchFromGitLab
, appstream-glib
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, evolution-data-server
, feedbackd
, gtk3
, json-glib
, libgcrypt
, libhandy
, libphonenumber
, olm
, pidgin
, protobuf
, sqlite
, plugins ? [ ]
}:

stdenv.mkDerivation rec {
  pname = "chatty";
  version = "0.3.2";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "chatty";
    rev = "v${version}";
    sha256 = "sha256-/l8hysfBmXLbs2COIVjdr2JC1qX/c66DqOm2Gyqb9s8=";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    evolution-data-server
    feedbackd
    gtk3
    json-glib
    libgcrypt
    libhandy
    libphonenumber
    olm
    pidgin
    protobuf
    sqlite
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PURPLE_PLUGIN_PATH : ${pidgin.makePluginPath plugins}
      ${lib.concatMapStringsSep " " (p: p.wrapArgs or "") plugins}
    )
  '';

  meta = with lib; {
    description = "XMPP and SMS messaging via libpurple and ModemManager";
    homepage = "https://source.puri.sm/Librem5/chatty";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda tomfitzhenry ];
    platforms = platforms.linux;
  };
}

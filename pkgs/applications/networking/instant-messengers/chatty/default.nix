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
  version = "0.3.4";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "chatty";
    rev = "v${version}";
    sha256 = "0910f5bw75ph576gxbsd6ysdwnlk4ysdp0pml2i3mjqpcbkqfs3w";
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

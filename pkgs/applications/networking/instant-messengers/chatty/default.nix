{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, libhandy
, gtk3
, evolution-data-server
, desktop-file-utils
, wrapGAppsHook
, feedbackd
, sqlite
, python38
, pidgin
, plugins ? []
, symlinkJoin
, makeWrapper
}:

let unwrapped = stdenv.mkDerivation rec {
  pname = "chatty";
  version = "0.1.14";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "chatty";
    rev = "v${version}";
    sha256 = "1pln4sw9phiz6ywn0p0mnxwwrbrpqx8f6n5mqnrp8g59dq9g0ww1";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    wrapGAppsHook
    python38  # needed for postinstall.py
  ];

  buildInputs = [
    feedbackd
    libhandy
    evolution-data-server
    gtk3
    libhandy
    pidgin  # libpurple
    sqlite
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = with stdenv.lib; {
    description = "XMPP and SMS messaging via libpurple and ModemManager";
    homepage = "https://source.puri.sm/Librem5/chatty";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ masipcat ];
    platforms = platforms.linux;
  };
};
in if plugins == [] then unwrapped
  else import ./wrapper.nix {
    chatty = unwrapped;
    inherit makeWrapper symlinkJoin plugins pidgin;
  }

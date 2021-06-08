{ fetchFromGitHub, lib, stdenv
, desktop-file-utils, meson, ninja, pkg-config, vala, wrapGAppsHook, xvfb-run
, gtk3, libXtst, libpeas, zeitgeist
, appindicatorSupport ? false, libayatana-appindicator }:

stdenv.mkDerivation rec {
  pname = "diodon";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "diodon-dev";
    repo = pname;
    rev = version;
    sha256 = "1sa38v3lfb95m4f6ngc7zw1mm8ay3h4m3n11dqfn6vx9dwdbx215";
  };

  nativeBuildInputs = [
    desktop-file-utils meson ninja pkg-config vala wrapGAppsHook xvfb-run
  ];
  buildInputs = [
    gtk3 libXtst libpeas zeitgeist
  ] ++ lib.optionals appindicatorSupport [ libayatana-appindicator ];
  mesonFlags = lib.optionals (!appindicatorSupport) [
    "-Ddisable-indicator-plugin=true"
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Integrated clipboard manager for the Gnome/Unity desktop";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ McSinyx ];
  };
}

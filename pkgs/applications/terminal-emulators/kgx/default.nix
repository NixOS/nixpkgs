{ lib
, stdenv
, genericBranding ? false
, fetchFromGitLab
, gettext
, gnome
, libgtop
, gtk3
, libhandy
, pcre2
, vte
, appstream-glib
, desktop-file-utils
, git
, meson
, ninja
, pkg-config
, python3
, sassc
, wrapGAppsHook
}:

stdenv.mkDerivation {
  pname = "kgx";
  version = "unstable-2021-03-13";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "ZanderBrown";
    repo = "kgx";
    rev = "105adb6a8d09418a3ce622442aef6ae623dee787";
    sha256 = "0m34y0nbcfkyicb40iv0iqaq6f9r3f66w43lr803j3351nxqvcz2";
  };

  buildInputs = [
    gettext
    libgtop
    gnome.nautilus
    gtk3
    libhandy
    pcre2
    vte
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    git
    meson
    ninja
    pkg-config
    python3
    sassc
    wrapGAppsHook
  ];

  mesonFlags = lib.optional genericBranding "-Dgeneric=true";

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  preFixup = ''
    substituteInPlace $out/share/applications/org.gnome.zbrown.KingsCross.desktop \
      --replace "Exec=kgx" "Exec=$out/bin/kgx"
  '';

  meta = with lib; {
    description = "Simple user-friendly terminal emulator for the GNOME desktop";
    homepage = "https://gitlab.gnome.org/ZanderBrown/kgx";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zhaofengli ];
    platforms = platforms.linux;
  };
}

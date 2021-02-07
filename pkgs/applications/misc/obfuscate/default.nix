{ stdenv
, lib
, fetchgit
, meson
, ninja
, wrapGAppsHook
, pkg-config
, gtk3
, glib
, gdk-pixbuf
, rustPlatform
, desktop-file-utils
, appstream-glib
, python3
, librsvg
}:

rustPlatform.buildRustPackage rec {
  pname = "obfuscate";
  version = "unstable"; # latest tag v0.0.2 is broken

  src = fetchgit {
    url = "https://gitlab.gnome.org/World/obfuscate.git";
    rev = "1ec7e2d2b1a78c15a98cdb76be6a1d285accfa54";
    sha256 = "1v58ma9gb2nrin2d2q2ww2qdhyd51blldnycljpf0qf1j6zj83cp";
  };

  cargoSha256 = "sha256-po1hxBh3g8P3dfUTqeFCpnFg2W5VYKvQ1fS550qcLqI=";

  nativeBuildInputs = [
    meson
    ninja
    glib
    gtk3
    gdk-pixbuf
    wrapGAppsHook
    pkg-config
    desktop-file-utils
    appstream-glib
    python3
  ];

  buildInputs = [
    gtk3
    glib
    librsvg
    gdk-pixbuf
  ];

  buildPhase = ''
    patchShebangs build-aux/meson_post_install.py
    mesonConfigurePhase
    ninjaBuildPhase
  '';

  installPhase = ''
    ninjaInstallPhase
  '';

  meta = with lib; {
    description = "Censor private information";
    homepage = "https://gitlab.gnome.org/World/obfuscate";
    license = licenses.gpl3;
    maintainers = [ maintainers.mkg20001 ];
    platforms = platforms.unix;
  };
}

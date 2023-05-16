<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkg-config
, wrapGAppsHook
, desktop-file-utils
, discount
, glib
, gtk3
, gtksourceview4
, gtkspell3
, json-glib
, libarchive
, libgee
, libhandy
, libsecret
, libxml2
, link-grammar
, webkitgtk_4_1
}:

stdenv.mkDerivation rec {
  pname = "thiefmd";
  version = "0.2.7";
=======
{ lib, stdenv, fetchFromGitHub, wrapGAppsHook, cmake, desktop-file-utils, glib
, meson, ninja, pkg-config, vala, clutter, discount, gtk3, gtksourceview4, gtkspell3
, libarchive, libgee, libhandy, libsecret, link-grammar, webkitgtk }:

stdenv.mkDerivation rec {
  pname = "thiefmd";
  version = "0.2.5-stability";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kmwallio";
    repo = "ThiefMD";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-noNfGFMeIyKhAgiovJDn91TLELAOQ4nD/5QlQfsKTII=";
=======
    sha256 = "sha256-cUZ7NVGe4e9ZISo9gjWFuDNCyF3rsQtrDX+ureyqtwM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
<<<<<<< HEAD
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook
    desktop-file-utils
  ];

  buildInputs = [
    discount # libmarkdown
    glib
    gtk3
    gtksourceview4
    gtkspell3
    json-glib
    libarchive
    libgee
    libhandy
    libsecret
    libxml2
    link-grammar
    webkitgtk_4_1
  ];

  meta = with lib; {
    description = "Markdown & Fountain editor that helps with organization and management";
    homepage = "https://thiefmd.com";
    downloadPage = "https://github.com/kmwallio/ThiefMD";
    mainProgram = "com.github.kmwallio.thiefmd";
=======
    cmake desktop-file-utils glib meson wrapGAppsHook
    ninja pkg-config vala
  ];

  buildInputs = [
    clutter discount gtk3 gtksourceview4 gtkspell3
    libarchive libgee libhandy libsecret link-grammar
    webkitgtk
  ];

  dontUseCmakeConfigure = true;

  postInstall = ''
    mv $out/share/applications/com.github.kmwallio.thiefmd.desktop \
      $out/share/applications/thiefmd.desktop
    substituteInPlace $out/share/applications/thiefmd.desktop \
      --replace 'Exec=com.github.kmwallio.' Exec=$out/bin/

    makeWrapper $out/bin/com.github.kmwallio.thiefmd \
      $out/bin/thiefmd \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/"
  '';

  meta = with lib; {
    description = "Markdown & Fountain editor that helps with organization and management";
    homepage = "https://thiefmd.com";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}

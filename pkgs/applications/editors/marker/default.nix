{ stdenv
, lib
, fetchFromGitHub
, itstool
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gtk3
, gtksourceview
, gtkspell3
<<<<<<< HEAD
, webkitgtk_4_1
=======
, webkitgtk
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pandoc
}:

stdenv.mkDerivation rec {
  pname = "marker";
<<<<<<< HEAD
  version = "2023.05.02";
=======
  version = "2020.04.04.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fabiocolacio";
    repo = "Marker";
    rev = version;
    fetchSubmodules = true;
<<<<<<< HEAD
    sha256 = "sha256-HhDhigQ6Aqo8R57Yrf1i69sM0feABB9El5R5OpzOyB0=";
=======
    sha256 = "sha256-wLR1FQqlLA02ed/JoAcxRHhIVua1FibAee1PC2zOPOM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gtksourceview
    gtkspell3
<<<<<<< HEAD
    webkitgtk_4_1
    pandoc
  ];

  postPatch = ''
    meson rewrite kwargs set project / version '${version}'
  '';

  meta = with lib; {
    homepage = "https://fabiocolacio.github.io/Marker/";
    description = "Markdown editor for the Linux desktop made with GTK3";
    maintainers = with maintainers; [ trepetti aleksana ];
=======
    webkitgtk
    pandoc
  ];

  meta = with lib; {
    homepage = "https://fabiocolacio.github.io/Marker/";
    description = "Markdown editor for the Linux desktop";
    maintainers = with maintainers; [ trepetti ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    changelog = "https://github.com/fabiocolacio/Marker/releases/tag/${version}";
  };
}

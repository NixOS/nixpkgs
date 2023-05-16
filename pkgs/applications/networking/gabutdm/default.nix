{ lib
, stdenv
, fetchFromGitHub
, meson
, pkg-config
, cmake
, ninja
, vala
, wrapGAppsHook4
, desktop-file-utils
, sqlite
, libcanberra
, libsoup_3
, libgee
, json-glib
, qrencode
, curl
}:

stdenv.mkDerivation rec {
  pname = "gabutdm";
<<<<<<< HEAD
  version = "2.1.6";
=======
  version = "2.1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gabutakut";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-ai5LsoK21XwXqL4LRuKsOR1/JV6LnP+1ZJ9fMHpj178=";
=======
    hash = "sha256-8fV7STYSpmNnLyoAjz+RuF/0nFeNiu8AIxkON1MbWr4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    pkg-config
    cmake
    ninja
    vala
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    sqlite
    libcanberra
    libsoup_3
    libgee
    json-glib
    qrencode
    curl
  ];

  postPatch = ''
    substituteInPlace meson/post_install.py \
      --replace gtk-update-icon-cache gtk4-update-icon-cache
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "Simple and fast download manager";
=======
    description = "Simple and faster download manager";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/gabutakut/gabutdm";
    license = licenses.lgpl21Plus;
    mainProgram = "com.github.gabutakut.gabutdm";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}

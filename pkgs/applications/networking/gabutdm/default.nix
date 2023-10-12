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
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "gabutakut";
    repo = pname;
    rev = version;
    hash = "sha256-ai5LsoK21XwXqL4LRuKsOR1/JV6LnP+1ZJ9fMHpj178=";
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
    description = "Simple and fast download manager";
    homepage = "https://github.com/gabutakut/gabutdm";
    license = licenses.lgpl21Plus;
    mainProgram = "com.github.gabutakut.gabutdm";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}

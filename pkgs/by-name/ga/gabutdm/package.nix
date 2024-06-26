{ lib
, stdenv
, fetchFromGitHub
, meson
, pkg-config
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
, libadwaita
, aria2
}:

stdenv.mkDerivation rec {
  pname = "gabutdm";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "gabutakut";
    repo = "gabutdm";
    rev = version;
    hash = "sha256-HF+zBDkA9fYauLUYsvJJxcRggHu+5qH4rm0IM/tL9Hc=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
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
    libadwaita
  ];

  postPatch = ''
    substituteInPlace meson/post_install.py \
      --replace-fail gtk-update-icon-cache gtk4-update-icon-cache
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ aria2 ]}
    )
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

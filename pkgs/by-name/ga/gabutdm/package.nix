{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  vala,
  wrapGAppsHook4,
  desktop-file-utils,
  sqlite,
  libcanberra,
  libsoup_3,
  libgee,
  json-glib,
  qrencode,
  curl,
  libadwaita,
  aria2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gabutdm";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "gabutakut";
    repo = "gabutdm";
    rev = finalAttrs.version;
    hash = "sha256-nzhEJiGBH+semfwLPdpIfPNGQLorqPwwmiAUNM91Br4=";
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

  meta = {
    description = "Simple and fast download manager";
    homepage = "https://github.com/gabutakut/gabutdm";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "com.github.gabutakut.gabutdm";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})

{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, jsoncpp
, taglib
, curl
, curlpp
, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, desktop-file-utils
, chromaprint # fpcalc
}:

stdenv.mkDerivation rec {
  pname = "tagger";
  version = "2022.11.2";

  src = fetchFromGitHub {
    owner = "nlogozzo";
    repo = "NickvisionTagger";
    rev = version;
    hash = "sha256-gFpnTuUROYwPANrkD+g7a3FHSCVY2oB97flCK+LLowY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    jsoncpp
    taglib
    curl
    curlpp
  ];

  # Don't install compiled binary
  postPatch = ''
    sed -i '/fpcalc/d' meson.build
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ chromaprint ]}"
    )
  '';

  meta = with lib; {
    description = "An easy-to-use music tag (metadata) editor";
    homepage = "https://github.com/nlogozzo/NickvisionTagger";
    mainProgram = "org.nickvision.tagger";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}

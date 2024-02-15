{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, vala
, wrapGAppsHook
, desktop-file-utils
, libgee
, pantheon
, libxml2
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "annotator";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = "annotator";
    rev = version;
    hash = "sha256-VHvznkGvrE8o9qq+ijrIStSavq46dS8BqclWEWZ8mG8=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    wrapGAppsHook
    desktop-file-utils
  ];

  buildInputs = [
    libgee
    pantheon.granite
    libxml2
    libhandy
  ];

  meta = with lib; {
    description = "Image annotation for Elementary OS";
    homepage = "https://github.com/phase1geo/Annotator";
    license = licenses.gpl3Plus;
    mainProgram = "com.github.phase1geo.annotator";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}

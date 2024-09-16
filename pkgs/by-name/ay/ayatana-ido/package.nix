{
  cmake,
  fetchFromGitHub,
  glib,
  gtk3,
  lib,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "ayatana-ido";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = pname;
    rev = version;
    sha256 = "sha256-WEPW9BstDv2k/5dTEDQza3eOQ9bd6CEVvmd817sEPAs=";
  };

  nativeBuildInputs = [
    cmake
    glib # for glib-mkenums
    pkg-config
  ];

  buildInputs = [ gtk3 ];

  strictDeps = true;

  meta = with lib; {
    description = "Ayatana Display Indicator Objects";
    homepage = "https://github.com/AyatanaIndicators/ayatana-ido";
    changelog = "https://github.com/AyatanaIndicators/ayatana-ido/blob/${version}/ChangeLog";
    license = [
      licenses.lgpl3Plus
      licenses.lgpl21Plus
    ];
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.linux;
  };
}

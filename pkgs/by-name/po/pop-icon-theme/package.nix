{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  meson,
  ninja,
  gtk3,
  adwaita-icon-theme,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pop-icon-theme";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "icon-theme";
    rev = "v${version}";
    sha256 = "sha256-V8xBZj6T4Ly/GHV0CVLZ1a4UZbmCkhYRe05qUfJk7Wg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gtk3
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  meta = with lib; {
    description = "Icon theme for Pop!_OS with a semi-flat design and raised 3D motifs";
    homepage = "https://github.com/pop-os/icon-theme";
    license = with licenses; [
      cc-by-sa-40
      gpl3
    ];
    platforms = platforms.linux; # hash mismatch on darwin due to file names differing only in case
    maintainers = with maintainers; [ romildo ];
  };
}

{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
  gtk3,
  pantheon,
  gnome-icon-theme,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "faba-icon-theme";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "moka-project";
    repo = "faba-icon-theme";
    rev = "v${version}";
    sha256 = "0xh6ppr73p76z60ym49b4d0liwdc96w41cc5p07d48hxjsa6qd6n";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
    gtk3
  ];

  propagatedBuildInputs = [
    pantheon.elementary-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs meson/post_install.py
  '';

  meta = {
    description = "Sexy and modern icon theme with Tango influences";
    homepage = "https://snwh.org/moka";
    license = with lib.licenses; [
      cc-by-sa-40
      gpl3
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ romildo ];
  };
}

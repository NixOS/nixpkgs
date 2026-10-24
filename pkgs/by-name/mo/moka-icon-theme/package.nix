{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  meson,
  ninja,
  gtk3,
  python3,
  faba-icon-theme,
  hicolor-icon-theme,
  jdupes,
}:

stdenvNoCC.mkDerivation {
  pname = "moka-icon-theme";
  version = "5.4.0-unstable-2019-05-30";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snwh";
    repo = "moka-icon-theme";
    rev = "c0355ea31e5cfdb6b44d8108f602d66817546a09";
    hash = "sha256-iIGUvz9On4qPNBLRE8KgSTlYeqIBC900bJwkOrNyk1Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gtk3
    python3
    jdupes
  ];

  propagatedBuildInputs = [
    faba-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary for this package
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  postPatch = ''
    patchShebangs meson/post_install.py
  '';

  postInstall = ''
    # replace duplicate files with symlinks
    jdupes -l -r $out/share/icons
  '';

  meta = {
    description = "Icon theme designed with a minimal flat style using simple geometry and bright colours";
    homepage = "https://snwh.org/moka";
    license = with lib.licenses; [
      cc-by-sa-40
      gpl3Only
    ];
    # darwin cannot deal with file names differing only in case
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
  };
}

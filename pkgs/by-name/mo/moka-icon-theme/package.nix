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
  version = "unstable-2019-05-29";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = "moka-icon-theme";
    rev = "c0355ea31e5cfdb6b44d8108f602d66817546a09";
    sha256 = "0m4kfarkl94wdhsds2q1l9x5hfa9l3117l8j6j7qm7sf7yzr90c8";
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

  meta = with lib; {
    description = "Icon theme designed with a minimal flat style using simple geometry and bright colours";
    homepage = "https://snwh.org/moka";
    license = with licenses; [
      cc-by-sa-40
      gpl3Only
    ];
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}

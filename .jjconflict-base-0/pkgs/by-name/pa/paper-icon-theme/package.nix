{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  meson,
  ninja,
  gtk3,
  adwaita-icon-theme,
  gnome-icon-theme,
  hicolor-icon-theme,
  jdupes,
}:

stdenvNoCC.mkDerivation rec {
  pname = "paper-icon-theme";
  version = "unstable-2020-03-12";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = pname;
    rev = "aa3e8af7a1f0831a51fd7e638a4acb077a1e5188";
    sha256 = "0x6qzch4rrc8firb1dcf926j93gpqxvd7h6dj5wwczxbvxi5bd77";
  };

  nativeBuildInputs = [
    meson
    ninja
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary for this package
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  postInstall = ''
    # The cache for Paper-Mono-Dark is missing
    gtk-update-icon-cache "$out"/share/icons/Paper-Mono-Dark;

    # replace duplicate files with symlinks
    jdupes -l -r $out/share/icons
  '';

  meta = with lib; {
    description = "Modern icon theme designed around bold colours and simple geometric shapes";
    homepage = "https://snwh.org/paper";
    license = with licenses; [
      cc-by-sa-40
      lgpl3
    ];
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}

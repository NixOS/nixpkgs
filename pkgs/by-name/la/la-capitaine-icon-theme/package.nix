{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-icon-theme,
  hicolor-icon-theme,
  pantheon,
  libsForQt5,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "la-capitaine-icon-theme";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "keeferrourke";
    repo = "la-capitaine-icon-theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+n+GN5sCcWTyAigtgyudliOTulP7ECoOCYdm01trokU=";
  };

  propagatedBuildInputs = [
    libsForQt5.breeze-icons
    pantheon.elementary-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs configure

    substituteInPlace configure \
      --replace 'DISTRO=$(format "$(lsb_release -si 2>/dev/null)")' 'DISTRO=nixos'
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/la-capitaine-icon-theme
    cp -a * $out/share/icons/la-capitaine-icon-theme
    rm $out/share/icons/la-capitaine-icon-theme/{configure,COPYING,LICENSE,*.md}
    cp "$out/share/icons/la-capitaine-icon-theme/places/scalable/"distributor-logo-{archlinux,debian,kubuntu}.svg "$out/share/icons/la-capitaine-icon-theme/apps/scalable/"
    runHook postInstall
  '';

  meta = {
    description = "Icon theme inspired by macOS and Google's Material Design";
    homepage = "https://github.com/keeferrourke/la-capitaine-icon-theme";
    license = with lib.licenses; [
      gpl3Plus
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
  };
})

{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  kdePackages,
  hicolor-icon-theme,
  gitUpdater,
  color ? null,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "neuwaita-icon-theme";
  version = "0-unstable-2025-12-04";

  src = fetchFromGitHub {
    owner = "RusticBard";
    repo = "Neuwaita";
    rev = "7c88c0de2107819fbb3c0228010957a3526ea0c2";
    hash = "sha256-y24OlPeY3MK4Hfx/C7u/RBCU8LGH4u6sLEIdEgcnBe0=";
  };

  propagatedBuildInputs = [
    kdePackages.breeze-icons
    hicolor-icon-theme
  ];

  dontWrapQtApps = true;

  dontDropIconThemeCache = true;

  postPatch = ''
    substituteInPlace ./change-color.sh \
      --replace-fail "~/.local/share/icons/Neuwaita/Palette.txt" ./Neuwaita/Palette.txt \
      --replace-fail "~/.local/share/icons/Neuwaita/scalable/places/folder.svg" $out/share/icons/Neuwaita/scalable/places/folder.svg \
      --replace-fail "gsettings set org.gnome.desktop.interface icon-theme 'Hicolor'" \# \
      --replace-fail "gsettings set org.gnome.desktop.interface icon-theme 'Neuwaita'" \#
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/Neuwaita
    cp -r ./scalable $out/share/icons/Neuwaita

    ${lib.optionalString (color != null) "sh ./change-color.sh ${color}"}

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Different take on adwaita theme";
    homepage = "https://github.com/RusticBard/Neuwaita";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      claymorwan
    ];
  };
})

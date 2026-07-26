{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  kdePackages,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "application-title-bar";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "antroids";
    repo = "application-title-bar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zph+TwPXyf2r3PpJqWSdR0V9fFt2b2XWVfsAzuY3bP4=";
  };

  propagatedUserEnvPkgs = with kdePackages; [ kconfig ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/com.github.antroids.application-title-bar
    cp -r package/* $out/share/plasma/plasmoids/com.github.antroids.application-title-bar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "KDE Plasma6 widget with window controls";
    homepage = "https://github.com/antroids/application-title-bar";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})

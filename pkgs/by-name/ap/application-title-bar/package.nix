{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  kdePackages,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "application-title-bar";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "antroids";
    repo = "application-title-bar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YSzXjFPCG/bs1Qm9YvoEDcM9GmlSosf2KAyz+7lx6Xg=";
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

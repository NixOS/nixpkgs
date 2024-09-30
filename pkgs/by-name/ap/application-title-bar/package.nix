{ lib
, stdenv
, fetchFromGitHub
, kdePackages
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "application-title-bar";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "antroids";
    repo = "application-title-bar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kvFUz0m222jTGrkqLyYmnW0o4MXU9lLAsyk6QBAJHr8=";
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

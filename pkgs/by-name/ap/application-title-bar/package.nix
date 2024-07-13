{ lib
, stdenv
, fetchFromGitHub
, kdePackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "application-title-bar";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "antroids";
    repo = "application-title-bar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hA8aK2rd53VyYQnR0SG4KfwycCqT1EYB7iAJvkDGvYs=";
  };

  propagatedUserEnvPkgs = with kdePackages; [ kconfig ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/com.github.antroids.application-title-bar
    cp -r package/* $out/share/plasma/plasmoids/com.github.antroids.application-title-bar
    runHook postInstall
  '';

  meta = {
    description = "KDE Plasma6 widget with window controls";
    homepage = "https://github.com/antroids/application-title-bar";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})

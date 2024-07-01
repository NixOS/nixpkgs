{ lib
, stdenv
, fetchFromGitHub
, kdePackages
}:

stdenv.mkDerivation rec {
  pname = "application-title-bar";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "antroids";
    repo = "application-title-bar";
    rev = "v${version}";
    hash = "sha256-r15wZCioWrTr5mA0WARFd4j8zwWIWU4wEv899RSURa4=";
  };

  propagatedUserEnvPkgs = with kdePackages; [ kconfig ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/com.github.antroids.application-title-bar
    cp -r $src/package/* $out/share/plasma/plasmoids/com.github.antroids.application-title-bar
    runHook postInstall
  '';

  meta = with lib; {
    description = "KDE Plasma6 widget with window controls";
    homepage = "https://github.com/antroids/application-title-bar";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ HeitorAugustoLN ];
    platforms = platforms.linux;
  };
}

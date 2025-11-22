{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  kdePackages,
}:

stdenvNoCC.mkDerivation {
  pname = "shutdown_or_switch";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Davide-sd";
    repo = "shutdown_or_switch";
    rev = "3e426e40364fdc8f759957105b207bfa4b210b19";
    hash = "sha256-NbZyQu23gr0O1QHbhLbcaTXV6t639akW9PF0Jq4Sc3Y=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids/
    cp -r $src/package $out/share/plasma/plasmoids/org.kde.plasma.shutdownorswitch

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Davide-sd/shutdown_or_switch";
    description = "KDE Plasma widget to quickly access the shutdown options or switch user";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ Svenum ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
}

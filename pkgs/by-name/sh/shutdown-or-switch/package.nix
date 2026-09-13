{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  kdePackages,
}:

stdenvNoCC.mkDerivation rec {
  pname = "shutdown-or-switch";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "Davide-sd";
    repo = "shutdown_or_switch";
    tag = "v${version}";
    hash = "sha256-nCSHYBQcw6Ids/+xwqz2vfn8TaLTUNhP86kMUluMWN0=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids/
    cp -r package $out/share/plasma/plasmoids/org.kde.plasma.shutdownorswitch

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

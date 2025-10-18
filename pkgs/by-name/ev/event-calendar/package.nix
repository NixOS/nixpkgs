{ lib
, stdenvNoCC
, fetchFromGitHub
, gnused
, makeWrapper
, libsForQt5
, python3
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "event-calendar";
  version = "unstable-2023-04-20";

  # Pulling from fork with Google Calendar fix until it gets fixed in main repo
  # https://github.com/Zren/plasma-applet-eventcalendar/issues/352
  src = fetchFromGitHub {
    owner = "gaganpreet";
    repo = "plasma-applet-eventcalendar";
    rev = "bdad0b77657550759e76553f79b837aac8edc5a7";
    hash = "sha256-kAMsG/22KailV1r++h9lTIF9F+eixho42AyxmPfWVGc=";
  };

  nativeBuildInputs = [
    gnused
    makeWrapper
  ];

  installerDeps = with libsForQt5; [
    kde-cli-tools
    kconfig
    kpackage
  ];

  uninstallerDeps = with libsForQt5; [ kpackage ];

  buildPhase = ''
    runHook preBuild

    echo ${ lib.strings.escapeShellArg ( builtins.readFile ./install-event-calendar ) } > install-event-calendar
    substituteInPlace install-event-calendar \
      --replace PACKAGE_DIR $out/share/event-calendar \
      --replace VERSION ${finalAttrs.version}
    chmod +x install-event-calendar

    echo ${ lib.strings.escapeShellArg ( builtins.readFile ./uninstall-event-calendar ) } > uninstall-event-calendar
    substituteInPlace uninstall-event-calendar --replace PACKAGE_DIR $out/share/event-calendar
    chmod +x uninstall-event-calendar

    substituteInPlace package/contents/scripts/notification.py \
      --replace /usr/bin/python3 ${python3}/bin/python3
    substituteInPlace package/contents/scripts/konsolekalendar.py \
      --replace /bin/python3 ${python3}/bin/python3
    find package/contents/ui -type f -exec sed -i 's#python3#${python3}/bin/python3#g' {} +

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r package $out/share/event-calendar
    mkdir $out/bin
    cp install-event-calendar uninstall-event-calendar $out/bin
    wrapProgram $out/bin/install-event-calendar --prefix PATH : ${ lib.makeBinPath finalAttrs.installerDeps }
    wrapProgram $out/bin/uninstall-event-calendar --prefix PATH : ${ lib.makeBinPath finalAttrs.uninstallerDeps }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Plasmoid for a calendar and agenda with weather that syncs to Google Calendar";
    homepage = "https://store.kde.org/p/998901/";
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = licenses.gpl2;
    maintainers = with maintainers; [ prominentretail ];
    platforms = platforms.linux;
    mainProgram = "install-event-calendar";
  };
})

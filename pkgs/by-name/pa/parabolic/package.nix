{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, gtk4
, libadwaita
, pkg-config
, wrapGAppsHook4
, glib
, shared-mime-info
, gdk-pixbuf
, blueprint-compiler
, python3
, ffmpeg
}:

buildDotnetModule rec {
  pname = "parabolic";
  version = "2024.5.0";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "Parabolic";
    rev = version;
    hash = "sha256-awbCn7W7RUSuEByXxLGrsmYjmxCrwywhhrMJq/iM1Uc=";
    fetchSubmodules = true;
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  pythonEnv = python3.withPackages(ps: with ps; [ yt-dlp ]);

  projectFile = "NickvisionTubeConverter.GNOME/NickvisionTubeConverter.GNOME.csproj";
  nugetDeps = ./deps.json;
  executables = "NickvisionTubeConverter.GNOME";

   nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    glib
    shared-mime-info
    gdk-pixbuf
    blueprint-compiler
  ];

  buildInputs = [ gtk4 libadwaita ];

  runtimeDeps = [
    gtk4
    libadwaita
    glib
    gdk-pixbuf
  ];

  postPatch = ''
    substituteInPlace NickvisionTubeConverter.Shared/Linux/org.nickvision.tubeconverter.desktop.in --replace '@EXEC@' "NickvisionTubeConverter.GNOME"
  '';

  postInstall = ''
    install -Dm444 NickvisionTubeConverter.Shared/Resources/org.nickvision.tubeconverter.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 NickvisionTubeConverter.Shared/Resources/org.nickvision.tubeconverter-symbolic.svg -t $out/share/icons/hicolor/symbolic/apps/
    install -Dm444 NickvisionTubeConverter.Shared/Linux/org.nickvision.tubeconverter.desktop.in -T $out/share/applications/org.nickvision.tubeconverter.desktop
  '';

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ pythonEnv ffmpeg ]}" ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Download web video and audio";
    homepage = "https://github.com/NickvisionApps/Parabolic";
    license = licenses.mit;
    maintainers = with maintainers; [ ewuuwe ];
    mainProgram = "NickvisionTubeConverter.GNOME";
    platforms = platforms.linux;
  };
}

{ lib
, buildDotnetModule
, fetchFromGitHub
, blueprint-compiler
, pkg-config
, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, desktop-file-utils
, chromaprint # fpcalc
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "tagger";
  version = "2023.11.3";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "Tagger";
    rev = version;
    hash = "sha256-rWdCzqNgAozEDGzzE4CNVXGfK225MKZ1s9bLidiZ/y0=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = "NickvisionTagger.GNOME/NickvisionTagger.GNOME.csproj";
  nugetDeps = ./deps.nix;
  executables = "NickvisionTagger.GNOME";

  passthru.updateScript = ./update.sh;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    chromaprint
  ];

  runtimeDeps = [
    glib
    gtk4
    libadwaita
  ];

  # Tried to have cake handle install but couldn't figure it out
  postInstall = ''
    substituteInPlace NickvisionTagger.Shared/Linux/org.nickvision.tagger.desktop.in --replace '@EXEC@' "NickvisionTagger.GNOME"
    install -Dm444 NickvisionTagger.Shared/Resources/org.nickvision.tagger.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 NickvisionTagger.Shared/Resources/org.nickvision.tagger-symbolic.svg -t $out/share/icons/hicolor/symbolic/apps/
    install -Dm444 NickvisionTagger.Shared/Linux/org.nickvision.tagger.desktop.in -T $out/share/applications/org.nickvision.tagger.desktop
  '';

  meta = with lib; {
    description = "An easy-to-use music tag (metadata) editor";
    homepage = "https://github.com/NickvisionApps/Tagger";
    mainProgram = "org.nickvision.tagger";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}

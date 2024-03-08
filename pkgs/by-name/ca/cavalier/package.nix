{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, pkg-config
, blueprint-compiler
, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, cava
}:

buildDotnetModule rec {
  pname = "cavalier";
  version = "2024.1.0";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "Cavalier";
    rev = "refs/tags/${version}";
    hash = "sha256-SFhEKtYrlnkbLMnxU4Uf4jnFsw0MJHstgZgLLnGC2d8=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = "NickvisionCavalier.GNOME/NickvisionCavalier.GNOME.csproj";
  nugetDeps = ./deps.nix;
  executables = "NickvisionCavalier.GNOME";

  nativeBuildInputs = [
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  runtimeDeps = [
    glib
    gtk4
    libadwaita
  ];

  postInstall = ''
    substituteInPlace NickvisionCavalier.Shared/Linux/org.nickvision.cavalier.desktop.in \
      --replace-fail '@EXEC@' "NickvisionCavalier.GNOME"
    install -Dm444 NickvisionCavalier.Shared/Linux/org.nickvision.cavalier.desktop.in -T $out/share/applications/org.nickvision.cavalier.desktop
    install -Dm444 NickvisionCavalier.Shared/Resources/org.nickvision.cavalier.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 NickvisionCavalier.Shared/Resources/org.nickvision.cavalier-symbolic.svg -t $out/share/icons/hicolor/symbolic/apps/
  '';

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ cava ]}" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Visualize audio with CAVA";
    homepage = "https://github.com/NickvisionApps/Cavalier";
    mainProgram = "NickvisionCavalier.GNOME";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
}

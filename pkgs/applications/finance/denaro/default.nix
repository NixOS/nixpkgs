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
}:

buildDotnetModule rec {
  pname = "denaro";
  version = "2023.6.2";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "Denaro";
    rev = version;
    hash = "sha256-wnqk+UuOQc/Yph9MbQU8FRsNC/8ZQ9FxgF205pdHf+s=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  projectFile = "NickvisionMoney.GNOME/NickvisionMoney.GNOME.csproj";
  nugetDeps = ./deps.nix;
  executables = "NickvisionMoney.GNOME";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    glib # For glib-compile-resources
    shared-mime-info # For update-mime-database
    gdk-pixbuf # Fixes icon missing in envs where GDK_PIXBUF_MODULE_FILE is not set
    blueprint-compiler
  ];

  buildInputs = [ gtk4 libadwaita ]; # Used by blueprint-compiler

  # Denaro switches installation tool frequently (bash -> just -> cake)
  # For maintainability, let's do it ourselves
  postInstall = ''
    substituteInPlace NickvisionMoney.Shared/org.nickvision.money.desktop.in --replace '@EXEC@' "NickvisionMoney.GNOME"
    install -Dm444 NickvisionMoney.Shared/Resources/org.nickvision.money.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 NickvisionMoney.Shared/Resources/org.nickvision.money-symbolic.svg -t $out/share/icons/hicolor/symbolic/apps/
    install -Dm444 NickvisionMoney.Shared/org.nickvision.money.desktop.in -T $out/share/applications/org.nickvision.money.desktop
  '';

  runtimeDeps = [
    gtk4
    libadwaita
    glib # Fixes "Could not retrieve parent type - is the typeid valid?"
  ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Personal finance manager for GNOME";
    homepage = "https://github.com/nlogozzo/NickvisionMoney";
    mainProgram = "NickvisionMoney.GNOME";
    license = licenses.mit;
    changelog = "https://github.com/nlogozzo/NickvisionMoney/releases/tag/${version}";
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}

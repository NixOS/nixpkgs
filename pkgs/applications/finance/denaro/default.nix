{ lib
, stdenvNoCC
, buildDotnetModule
, fetchFromGitHub
, fetchpatch
, dotnetCorePackages
, gtk4
, libadwaita
, pkg-config
, wrapGAppsHook4
, glib
, shared-mime-info
, python3
, desktop-file-utils
, gdk-pixbuf
}:

buildDotnetModule rec {
  pname = "denaro";
  version = "2023.2.0";

  src = fetchFromGitHub {
    owner = "nlogozzo";
    repo = "NickvisionMoney";
    rev = version;
    hash = "sha256-ot6VfCzGrJnLaw658QsOe9M0HiqNDrtxvLWpXj9nXko=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  projectFile = "NickvisionMoney.GNOME/NickvisionMoney.GNOME.csproj";
  nugetDeps = ./deps.nix;
  executables = "NickvisionMoney.GNOME";

  # Prevent installing native libraries for all platforms
  dotnetBuildFlags = [ "--runtime" (dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system) ];
  dotnetInstallFlags = [ "--runtime" (dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system) ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    glib # For glib-compile-resources
    shared-mime-info # For update-mime-database
    python3
    desktop-file-utils
    gdk-pixbuf # Fixes icon missing in envs where GDK_PIXBUF_MODULE_FILE is not set
  ];

  postInstall = ''
    sh NickvisionMoney.GNOME/install_extras.sh $out
    desktop-file-edit $out/share/applications/org.nickvision.money.desktop \
      --set-key=Exec --set-value=$out/bin/NickvisionMoney.GNOME
  '';

  runtimeDeps = [
    gtk4
    libadwaita
    glib # Fixes "Could not retrieve parent type - is the typeid valid?"
  ];

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

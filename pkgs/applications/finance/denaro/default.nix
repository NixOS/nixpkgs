{ lib
<<<<<<< HEAD
, buildDotnetModule
, fetchFromGitHub
=======
, stdenvNoCC
, buildDotnetModule
, fetchFromGitHub
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dotnetCorePackages
, gtk4
, libadwaita
, pkg-config
, wrapGAppsHook4
, glib
, shared-mime-info
<<<<<<< HEAD
, gdk-pixbuf
, blueprint-compiler
=======
, python3
, desktop-file-utils
, gdk-pixbuf
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildDotnetModule rec {
  pname = "denaro";
<<<<<<< HEAD
  version = "2023.9.1";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "Denaro";
    rev = version;
    hash = "sha256-WODAdIKCnDaOWmLir1OfYfAUaULwV8yEFMlfyO/cmfE=";
=======
  version = "2023.2.2";

  src = fetchFromGitHub {
    owner = "nlogozzo";
    repo = "NickvisionMoney";
    rev = version;
    hash = "sha256-B84uzJ+B7kGU+O2tuObrIFCvgUfszLd1VU7F5tL90bU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  projectFile = "NickvisionMoney.GNOME/NickvisionMoney.GNOME.csproj";
  nugetDeps = ./deps.nix;
  executables = "NickvisionMoney.GNOME";

<<<<<<< HEAD
=======
  # Prevent installing native libraries for all platforms
  dotnetBuildFlags = [ "--runtime" (dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system) ];
  dotnetInstallFlags = [ "--runtime" (dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system) ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    glib # For glib-compile-resources
    shared-mime-info # For update-mime-database
<<<<<<< HEAD
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
=======
    python3
    desktop-file-utils
    gdk-pixbuf # Fixes icon missing in envs where GDK_PIXBUF_MODULE_FILE is not set
  ];

  postInstall = ''
    sh NickvisionMoney.GNOME/install_extras.sh $out
    desktop-file-edit $out/share/applications/org.nickvision.money.desktop \
      --set-key=Exec --set-value=$out/bin/NickvisionMoney.GNOME
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  runtimeDeps = [
    gtk4
    libadwaita
    glib # Fixes "Could not retrieve parent type - is the typeid valid?"
<<<<<<< HEAD
    gdk-pixbuf
  ];

  passthru.updateScript = ./update.sh;

=======
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Personal finance manager for GNOME";
    homepage = "https://github.com/nlogozzo/NickvisionMoney";
    mainProgram = "NickvisionMoney.GNOME";
    license = licenses.mit;
    changelog = "https://github.com/nlogozzo/NickvisionMoney/releases/tag/${version}";
<<<<<<< HEAD
    maintainers = with maintainers; [ chuangzhu kashw2 ];
=======
    maintainers = with maintainers; [ chuangzhu ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}

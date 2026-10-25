{
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
  lib,
}:
buildDotnetModule rec {
  pname = "melonloader-installer";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "LavaGang";
    repo = "MelonLoader.Installer";
    tag = version;
    hash = "sha256-6nyrHSD3x5Oh50ckDkWq6Fr3x4BFHsT4mn+N5QGJud4=";
  };

  patches = [
    ./disable-auto-updates.patch
  ];

  projectFile = "MelonLoader.Installer/MelonLoader.Installer.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  nugetDeps = ./deps.json;
  selfContainedBuild = true;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ copyDesktopItems ];

  postInstall = ''
    install -Dm644 Resources/ML_Icon.png $out/share/icons/MelonLoader.Installer.Linux.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "MelonLoader Installer";
      exec = meta.mainProgram;
      comment = meta.description;
      categories = [
        "Game"
        "Utility"
      ];
      icon = meta.mainProgram;
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://melonwiki.xyz";
    mainProgram = "MelonLoader.Installer.Linux";
    description = "Automated installer for MelonLoader, the universal mod-loader for games built in the Unity Engine";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ WillemToorenburgh ];
  };
}

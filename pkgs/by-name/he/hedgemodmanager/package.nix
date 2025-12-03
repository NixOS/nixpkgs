{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "hedgemodmanager";
  version = "8.0.0-beta4";

  src = fetchFromGitHub {
    owner = "hedge-dev";
    repo = "HedgeModManager";
    tag = finalAttrs.version;
    hash = "sha256-1uwcpeyOxwKI0fyAmchYEMqStF52wXkCZej+ZQ+aFeY=";
  };

  projectFile = "Source/HedgeModManager.UI/HedgeModManager.UI.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  postPatch = ''
    substituteInPlace flatpak/hedgemodmanager.desktop --replace-fail "/app/bin/HedgeModManager.UI" "HedgeModManager.UI"
  '';

  # https://github.com/hedge-dev/HedgeModManager/blob/8.0.0-beta4/flatpak/io.github.hedge_dev.hedgemodmanager.yml#L53-L55
  postInstall = ''
    install -Dm644 flatpak/hedgemodmanager.png $out/share/icons/hicolor/256x256/apps/io.github.hedge_dev.hedgemodmanager.png
    install -Dm644 flatpak/hedgemodmanager.metainfo.xml $out/share/metainfo/io.github.hedge_dev.hedgemodmanager.metainfo.xml
    install -Dm644 flatpak/hedgemodmanager.desktop $out/share/applications/io.github.hedge_dev.hedgemodmanager.desktop
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "unstable"
    ];
  };

  meta = {
    mainProgram = "HedgeModManager.UI";
    description = "Mod manager for Hedgehog Engine games";
    homepage = "https://github.com/hedge-dev/HedgeModManager";
    changelog = "https://github.com/hedge-dev/HedgeModManager/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})

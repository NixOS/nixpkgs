{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  nix-update-script,
  versionCheckHook,
}:

buildDotnetModule (finalAttrs: {
  pname = "hedgemodmanager";
  version = "8.0.0-beta7";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "hedge-dev";
    repo = "HedgeModManager";
    tag = finalAttrs.version;
    hash = "sha256-+Ia35SNlzcB/udCilldPxuMRJtsrAOIFjmX3kGyH5TM=";
  };

  postPatch = ''
    substituteInPlace flatpak/hedgemodmanager.desktop --replace-fail "/app/bin/HedgeModManager.UI" "HedgeModManager.UI"
    substituteInPlace Source/HedgeModManager.UI/Program.cs --replace-fail "ThisAssembly.GitCommitId[..7]" '""'
    substituteInPlace Source/HedgeModManager{,.UI}/*.csproj Source/Libraries/HedgeModManager.{Epic,Foundation,Steam}/*.csproj \
      --replace-fail '<TargetFramework>net8.0</' '<TargetFramework>net10.0</'
    substituteInPlace Source/Libraries/HedgeModManager.Text/HedgeModManager.Text.csproj \
      --replace-fail '<TargetFramework>net6.0</' '<TargetFramework>net10.0</'
  '';

  projectFile = "Source/HedgeModManager.UI/HedgeModManager.UI.csproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  executables = [ "HedgeModManager.UI" ];

  postInstall = ''
    install -Dm644 flatpak/hedgemodmanager.png $out/share/icons/hicolor/256x256/apps/io.github.hedge_dev.hedgemodmanager.png
    install -Dm644 flatpak/hedgemodmanager.metainfo.xml $out/share/metainfo/io.github.hedge_dev.hedgemodmanager.metainfo.xml
    install -Dm644 flatpak/hedgemodmanager.desktop $out/share/applications/io.github.hedge_dev.hedgemodmanager.desktop
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--help";
  versionCheckKeepEnvironment = [ "HOME" ];

  preVersionCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p "$HOME/.local/share"
    version="${lib.replaceStrings [ "-beta" ] [ " beta " ] finalAttrs.version}"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "unstable"
    ];
  };

  meta = {
    description = "Mod manager for Hedgehog Engine games";
    homepage = "https://github.com/hedge-dev/HedgeModManager";
    changelog = "https://github.com/hedge-dev/HedgeModManager/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.keenanweaver ];
    platforms = lib.platforms.linux;
    mainProgram = "HedgeModManager.UI";
  };
})

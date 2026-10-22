{
  fetchFromGitHub,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  ffmpeg_7,
}:
buildDotnetModule (finalAttrs: {
  pname = "sharpemu";
  version = "0.0.6-mono";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sharpemu";
    repo = "sharpemu";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dzEPNy7lwwlIUelmUB+mC2idWOBC6qEDXEnUlqXUXLg=";
  };

  projectFile = "src/SharpEmu.CLI/SharpEmu.CLI.csproj";
  executables = [ "SharpEmu" ];
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  nugetDeps = ./deps.json;

  postPatch = ''
    # Use packaged FFmpeg and omit the optional demo instead of downloading at build time.
    substituteInPlace src/SharpEmu.CLI/SharpEmu.CLI.csproj \
      --replace-fail 'BeforeTargets="Publish;Build"' 'BeforeTargets="Never"' \
      --replace-fail 'AfterTargets="Build"' 'AfterTargets="Never"'

    for file in \
      src/SharpEmu.HLE/FileSystem/ZArchiveCache.cs \
      src/SharpEmu.GUI/PerGameSettings.cs \
      src/SharpEmu.Libs/SaveData/SaveDataStorage.cs \
      src/SharpEmu.Core/Diagnostics/WindowsCrashCapture.cs \
      src/SharpEmu.GUI/GameLibraryCache.cs \
      src/SharpEmu.GUI/TrophyCache.cs \
      src/SharpEmu.GUI/GlobalCustomEnvironmentSettings.cs \
      src/SharpEmu.GUI/GameArtCache.cs \
      src/SharpEmu.Libs/Ampr/AmprFileRegistry.cs \
      src/SharpEmu.Libs/Gpu/Images/GuestImageCache.VolumeDump.cs \
      src/SharpEmu.Libs/VideoOut/VulkanVideoPresenter.ImageSnapshots.cs; do
      substituteInPlace "$file" \
        --replace-fail 'AppContext.BaseDirectory, "user"' 'Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "SharpEmu"'
    done

    substituteInPlace src/SharpEmu.CLI/Program.cs \
      --replace-fail 'Path.Combine(baseDirectory, "user", "logs")' 'Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "SharpEmu", "logs")'
    substituteInPlace src/SharpEmu.GUI/MainWindow.axaml.cs \
      --replace-fail 'Path.Combine(exeDirectory, "user", "logs")' 'Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "SharpEmu", "logs")'
    substituteInPlace src/SharpEmu.GUI/GuiSettings.cs \
      --replace-fail 'Path.Combine(AppContext.BaseDirectory, "gui-settings.json")' 'Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "SharpEmu", "gui-settings.json")'
    substituteInPlace src/SharpEmu.GUI/GuiLauncher.cs \
      --replace-fail 'Path.Combine(AppContext.BaseDirectory, "gui-crash.log")' 'Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "SharpEmu", "gui-crash.log")'

    for file in \
      src/SharpEmu.Libs/Kernel/KernelMemoryCompatExports.cs \
      src/SharpEmu.Libs/VideoOut/RenderDocCapture.cs \
      src/SharpEmu.Libs/VideoOut/VulkanPipelineCacheStorage.cs; do
      substituteInPlace "$file" \
        --replace-fail 'AppContext.BaseDirectory' 'Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "SharpEmu"'
    done

    substituteInPlace src/SharpEmu.Libs/Media/FfmpegRuntime.cs \
      --replace-fail 'Path.Combine(AppContext.BaseDirectory, "plugins")' '"${lib.getLib ffmpeg_7}/lib"'
  '';

  # The project invokes Build while publishing its project references, which
  # conflicts with buildDotnetModule's `dotnet publish --no-build`. The regular
  # build output already contains the self-contained executable and its files.
  installPhase = ''
    install -d "$out/lib/$pname"
    cp -r artifacts/bin/Release/net10.0/linux-x64/. "$out/lib/$pname/"
  '';

  meta = {
    description = "Experimental PlayStation 5 emulator";
    homepage = "https://github.com/sharpemu/sharpemu";
    changelog = "https//github.com/sharpemu/sharpemu/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.evanwporter ];
    platforms = lib.platforms.unix;
    mainProgram = "SharpEmu";
  };
})

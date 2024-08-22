{
  _7zz,
  avalonia,
  buildDotnetModule,
  copyDesktopItems,
  desktop-file-utils,
  dotnetCorePackages,
  fetchgit,
  imagemagick,
  lib,
  makeFontsConf,
  runCommand,
  xdg-utils,
  pname ? "nexusmods-app",
}:
let
  # From https://nexus-mods.github.io/NexusMods.App/developers/Contributing/#for-package-maintainers
  constants = [
    # Tell the app it is a distro package; affects wording in update prompts
    "INSTALLATION_METHOD_PACKAGE_MANAGER"

    # Don't include upstream's 7zz binary; we use the nixpkgs version
    "NEXUSMODS_APP_USE_SYSTEM_EXTRACTOR"
  ];
in
buildDotnetModule (finalAttrs: {
  inherit pname;
  version = "0.7.0";

  src = fetchgit {
    url = "https://github.com/Nexus-Mods/NexusMods.App.git";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-7o+orpXLvZa+F0wEh3nVnYMe4ZkiaVJQOWvhWdNmcSk=";
    fetchSubmodules = true;
    fetchLFS = true;
  };

  enableParallelBuilding = false;

  # If the whole solution is published, there seems to be a race condition where
  # it will sometimes publish the wrong version of a dependent assembly, for
  # example: Microsoft.Extensions.Hosting.dll 6.0.0 instead of 8.0.0.
  # https://learn.microsoft.com/en-us/dotnet/core/compatibility/sdk/7.0/solution-level-output-no-longer-valid
  # TODO: do something about this in buildDotnetModule
  projectFile = "src/NexusMods.App/NexusMods.App.csproj";
  testProjectFile = "NexusMods.App.sln";

  buildInputs = [
    # TODO: bump avalonia to 11.1.3
    # avalonia
  ];

  nativeCheckInputs = [ _7zz ];

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick # For resizing SVG icon in postInstall
  ];

  nugetDeps = ./deps.nix;
  mapNuGetDependencies = true;

  # TODO: remove .NET 8; StrawberryShake currently needs it
  dotnet-sdk =
    with dotnetCorePackages;
    combinePackages [
      sdk_9_0
      runtime_8_0
    ];
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  postPatch = ''
    # for some reason these tests fail (intermittently?) with a zero timestamp
    touch tests/NexusMods.UI.Tests/WorkspaceSystem/*.verified.png
  '';

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath finalAttrs.runtimeInputs}"
  ];

  postInstall = ''
    # Desktop entry
    # As per #308324, use mainProgram from PATH, instead of $out/bin/NexusMods.App
    install -D -m 444 -t $out/share/applications src/NexusMods.App/com.nexusmods.app.desktop
    substituteInPlace $out/share/applications/com.nexusmods.app.desktop \
      --replace-fail '${"$"}{INSTALL_EXEC}' "${finalAttrs.meta.mainProgram}"

    # AppStream metadata
    install -D -m 444 -t $out/share/metainfo src/NexusMods.App/com.nexusmods.app.metainfo.xml

    # Icon
    icon=src/NexusMods.App/icon.svg
    install -D -m 444 -T $icon $out/share/icons/hicolor/scalable/apps/com.nexusmods.app.svg

    # Bitmap icons
    for i in 16 24 48 64 96 128 256 512; do
      size=''${i}x''${i}
      dir=$out/share/icons/hicolor/$size/apps
      mkdir -p $dir
      convert -background none -resize $size $icon $dir/com.nexusmods.app.png
    done
  '';

  runtimeInputs = [
    _7zz
    desktop-file-utils
    xdg-utils
  ];

  executables = [ "NexusMods.App" ];

  dotnetBuildFlags = [
    # From https://github.com/Nexus-Mods/NexusMods.App/blob/v0.7.0/src/NexusMods.App/app.pupnet.conf#L38
    "--property:Version=${finalAttrs.version}"
    "--property:TieredCompilation=true"
    "--property:PublishReadyToRun=true"
    "--property:DefineConstants=${lib.strings.concatStringsSep "%3B" constants}"
  ];

  doCheck = true;

  dotnetTestFlags = [
    "--environment=USER=nobody"
    "--property:DefineConstants=${lib.strings.concatStringsSep "%3B" constants}"
  ];

  testFilters = [
    "Category!=Disabled"
    "FlakeyTest!=True"
    "RequiresNetworking!=True"
  ];

  disabledTests =
    [
      "NexusMods.UI.Tests.ImageCacheTests.Test_LoadAndCache_RemoteImage"
      "NexusMods.UI.Tests.ImageCacheTests.Test_LoadAndCache_ImageStoredFile"

      # Fails with: Expected a <System.ArgumentException> to be thrown, but no exception was thrown.
      "NexusMods.Networking.ModUpdates.Tests.PerFeedCacheUpdaterTests.Constructor_WithItemsFromDifferentGames_ShouldThrowArgumentException_InDebug"
    ]
    ++ lib.optionals (!_7zz.meta.unfree) [
      "NexusMods.Games.FOMOD.Tests.FomodXmlInstallerTests.InstallsFilesSimple_UsingRar"
    ];

  passthru = {
    tests =
      let
        runTest =
          name: script:
          runCommand "${pname}-test-${name}"
            {
              nativeBuildInputs = [ finalAttrs.finalPackage ];
              FONTCONFIG_FILE = makeFontsConf {
                fontDirectories = [ ];
              };
            }
            ''
              export XDG_DATA_HOME="$PWD/data"
              export XDG_STATE_HOME="$PWD/state"
              export XDG_CACHE_HOME="$PWD/cache"
              mkdir -p "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME"
              # TODO: on error, print $XDG_STATE_HOME/NexusMods.App/Logs/nexusmods.app.main.current.log
              ${script}
              touch $out
            '';
      in
      {
        serve = runTest "serve" ''
          NexusMods.App
        '';
        help = runTest "help" ''
          NexusMods.App --help
        '';
        associate-nxm = runTest "associate-nxm" ''
          NexusMods.App associate-nxm
        '';
        list-tools = runTest "list-tools" ''
          NexusMods.App list-tools
        '';
      };
    updateScript = ./update.bash;
  };

  meta = {
    mainProgram = "NexusMods.App";
    homepage = "https://github.com/Nexus-Mods/NexusMods.App";
    changelog = "https://github.com/Nexus-Mods/NexusMods.App/releases/tag/${finalAttrs.src.rev}";
    license = [ lib.licenses.gpl3Plus ];
    maintainers = with lib.maintainers; [
      l0b0
      MattSturgeon
    ];
    platforms = lib.platforms.linux;
    description = "Game mod installer, creator and manager";
    longDescription = ''
      A mod installer, creator and manager for all your popular games.

      Currently experimental and undergoing active development,
      new releases may include breaking changes!

      ${
        if _7zz.meta.unfree then
          ''
            This "unfree" variant includes support for mods packaged as RAR archives.
          ''
        else
          ''
            It is strongly recommended that you use the "unfree" variant of this package,
            which provides support for mods packaged as RAR archives.

            You can also enable unrar support manually, by overriding the `_7zz` used:

            ```nix
            pkgs.nexusmods-app.override {
              _7zz = pkgs._7zz-rar;
            }
            ```
          ''
      }
    '';
  };
})

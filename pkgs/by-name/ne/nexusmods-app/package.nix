{
  _7zz,
  buildDotnetModule,
  copyDesktopItems,
  desktop-file-utils,
  dotnetCorePackages,
  fetchFromGitHub,
  fontconfig,
  lib,
  libICE,
  libSM,
  libX11,
  nexusmods-app,
  runCommand,
  pname ? "nexusmods-app",
}:
buildDotnetModule rec {
  inherit pname;
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Nexus-Mods";
    repo = "NexusMods.App";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-FzQphMhiC1g+6qmk/R1v4rq2ldy35NcaWm0RR1UlwLA=";
  };

  # If the whole solution is published, there seems to be a race condition where
  # it will sometimes publish the wrong version of a dependent assembly, for
  # example: Microsoft.Extensions.Hosting.dll 6.0.0 instead of 8.0.0.
  # https://learn.microsoft.com/en-us/dotnet/core/compatibility/sdk/7.0/solution-level-output-no-longer-valid
  # TODO: do something about this in buildDotnetModule
  projectFile = "src/NexusMods.App/NexusMods.App.csproj";
  testProjectFile = "NexusMods.App.sln";

  nativeBuildInputs = [ copyDesktopItems ];

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  preConfigure = ''
    substituteInPlace Directory.Build.props \
      --replace '</PropertyGroup>' '<ErrorOnDuplicatePublishOutputFiles>false</ErrorOnDuplicatePublishOutputFiles></PropertyGroup>'
  '';

  postPatch = ''
    ln --force --symbolic "${lib.getExe _7zz}" src/ArchiveManagement/NexusMods.FileExtractor/runtimes/linux-x64/native/7zz

    # for some reason these tests fail (intermittently?) with a zero timestamp
    touch tests/NexusMods.UI.Tests/WorkspaceSystem/*.verified.png
  '';

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}"
    "--set APPIMAGE ${placeholder "out"}/bin/${meta.mainProgram}" # Make associating with nxm links work on Linux
  ];

  runtimeDeps = [
    fontconfig
    libICE
    libSM
    libX11
  ];

  executables = [ meta.mainProgram ];

  doCheck = true;

  dotnetTestFlags = [
    "--environment=USER=nobody"
    (
      "--filter="
      + lib.strings.concatStringsSep "&" (
        [
          "Category!=Disabled"
          "FlakeyTest!=True"
          "RequiresNetworking!=True"
          "FullyQualifiedName!=NexusMods.UI.Tests.ImageCacheTests.Test_LoadAndCache_RemoteImage"
          "FullyQualifiedName!=NexusMods.UI.Tests.ImageCacheTests.Test_LoadAndCache_ImageStoredFile"
        ]
        ++ lib.optionals (!_7zz.meta.unfree) [
          "FullyQualifiedName!=NexusMods.Games.FOMOD.Tests.FomodXmlInstallerTests.InstallsFilesSimple_UsingRar"
        ]
      )
    )
  ];

  passthru = {
    tests =
      let
        runTest =
          name: script:
          runCommand "${pname}-test-${name}"
            {
              # TODO: use finalAttrs when buildDotnetModule has support
              nativeBuildInputs = [ nexusmods-app ];
            }
            ''
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
    changelog = "https://github.com/Nexus-Mods/NexusMods.App/releases/tag/${src.rev}";
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
}

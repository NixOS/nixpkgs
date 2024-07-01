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
  enableUnfree ? false, # Set to true to support RAR format mods
}:
let
  _7zzWithOptionalUnfreeRarSupport = _7zz.override { inherit enableUnfree; };
in
buildDotnetModule rec {
  pname = "nexusmods-app" + lib.strings.optionalString enableUnfree "-unfree";

  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Nexus-Mods";
    repo = "NexusMods.App";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-FzQphMhiC1g+6qmk/R1v4rq2ldy35NcaWm0RR1UlwLA=";
  };

  projectFile = "NexusMods.App.sln";

  nativeBuildInputs = [ copyDesktopItems ];

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  preConfigure = ''
    substituteInPlace Directory.Build.props \
      --replace '</PropertyGroup>' '<ErrorOnDuplicatePublishOutputFiles>false</ErrorOnDuplicatePublishOutputFiles></PropertyGroup>'
  '';

  postPatch = ''
    ln --force --symbolic "${lib.getExe _7zzWithOptionalUnfreeRarSupport}" src/ArchiveManagement/NexusMods.FileExtractor/runtimes/linux-x64/native/7zz
  '';

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}"
    "--set APPIMAGE $out/bin/${meta.mainProgram}" # Make associating with nxm links work on Linux
  ];

  runtimeDeps = [
    fontconfig
    libICE
    libSM
    libX11
  ];

  executables = [ nexusmods-app.meta.mainProgram ];

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
        ++ lib.optionals (!enableUnfree) [
          "FullyQualifiedName!=NexusMods.Games.FOMOD.Tests.FomodXmlInstallerTests.InstallsFilesSimple_UsingRar"
        ]
      )
    )
  ];

  passthru = {
    tests =
      lib.attrsets.mapAttrs
        (
          tname: args:
          runCommand "${pname}-test-${tname}" { } ''
            ${lib.getExe nexusmods-app} ${args}
            touch $out
          ''
        )
        {
          serve = "";
          help = "--help";
          associate-nxm = "associate-nxm";
          list-tools = "list-tools";
        };
    updateScript = ./update.bash;
  };

  meta = {
    description =
      "Game mod manager, "
      + (if enableUnfree then "includes" else "use the unfree version if you need")
      + " support for mods packaged in RAR files";
    mainProgram = "NexusMods.App";
    homepage = "https://github.com/Nexus-Mods/NexusMods.App";
    changelog = "https://github.com/Nexus-Mods/NexusMods.App/releases/tag/${src.rev}";
    license = [ lib.licenses.gpl3Plus ];
    maintainers = with lib.maintainers; [
      l0b0
      MattSturgeon
    ];
    platforms = lib.platforms.linux;
  };
}

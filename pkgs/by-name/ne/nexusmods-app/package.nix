{
  _7zz,
  avalonia,
  buildDotnetModule,
  desktop-file-utils,
  dotnetCorePackages,
  fetchgit,
  imagemagick,
  lib,
  xdg-utils,
  nix-update-script,
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
  version = "0.13.4";

  src = fetchgit {
    url = "https://github.com/Nexus-Mods/NexusMods.App.git";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Ub6HjZChOhRUDYQ2TAnrwOtrW6ahP+k74vCAmLkYABA=";
    fetchSubmodules = true;
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
    imagemagick # For resizing SVG icon in postInstall
  ];

  nugetDeps = ./deps.json;
  mapNuGetDependencies = true;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  postPatch = ''
    # for some reason these tests fail (intermittently?) with a zero timestamp
    touch tests/NexusMods.UI.Tests/WorkspaceSystem/*.verified.png

    # Assertion assumes version is set to 0.0.1
    substituteInPlace tests/NexusMods.Telemetry.Tests/TrackingDataSenderTests.cs \
      --replace-fail 'cra_ct=v0.0.1' 'cra_ct=v${finalAttrs.version}'
  '';

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath finalAttrs.runtimeInputs}"
  ];

  postInstall = ''
    ${lib.strings.toShellVars {
      inherit (finalAttrs.meta) mainProgram;
      INSTALL_EXEC = "\${INSTALL_EXEC}";
      INSTALL_TRYEXEC = "\${INSTALL_TRYEXEC}";
    }}

    # Desktop entry
    # As per #308324, use mainProgram from PATH, instead of $out/bin/NexusMods.App
    install -D -m 444 -t $out/share/applications src/NexusMods.App/com.nexusmods.app.desktop
    substituteInPlace $out/share/applications/com.nexusmods.app.desktop \
      --replace-fail "$INSTALL_EXEC" "$mainProgram" \
      --replace-fail "$INSTALL_TRYEXEC" "$mainProgram"

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
      magick -background none $icon -resize $size $dir/com.nexusmods.app.png
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

  # Avoid running `dotnet test` in the main package:
  # - The test-suite is slow
  # - Some tests fail intermittently
  # - The package is often uncached; especially the unfree variant
  # - We can enable tests in a `passthru.tests` override
  doCheck = false;

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
      # Fails attempting to download game hashes DB from github:
      # HttpRequestException : Resource temporarily unavailable (github.com:443)
      "NexusMods.DataModel.SchemaVersions.Tests.LegacyDatabaseSupportTests.TestDatabase"
      "NexusMods.DataModel.SchemaVersions.Tests.MigrationSpecificTests.TestsFor_0001_ConvertTimestamps.OldTimestampsAreInRange"
      "NexusMods.DataModel.SchemaVersions.Tests.MigrationSpecificTests.TestsFor_0003_FixDuplicates.No_Duplicates"
      "NexusMods.DataModel.SchemaVersions.Tests.MigrationSpecificTests.TestsFor_0004_RemoveGameFiles.Test"

      # Fails attempting to fetch SMAPI version data from github:
      # https://github.com/erri120/smapi-versions/raw/main/data/game-smapi-versions.json
      "NexusMods.Games.StardewValley.Tests.SMAPIGameVersionDiagnosticEmitterTests.Test_TryGetLastSupportedSMAPIVersion"
    ]
    ++ lib.optionals (!_7zz.meta.unfree) [
      "NexusMods.Games.FOMOD.Tests.FomodXmlInstallerTests.InstallsFilesSimple_UsingRar"
    ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    desktop-file-utils
  ];

  # Upstream use ${...} templates in the desktop entry, so assert that we haven't missed any
  # See https://github.com/NixOS/nixpkgs/issues/421241
  installCheckPhase = ''
    runHook preInstallCheck

    echo 'Checking for issues in $out/share/applications/com.nexusmods.app.desktop'
    (
      cd $out/share/applications
      desktop-file-validate com.nexusmods.app.desktop
      if grep '\$' com.nexusmods.app.desktop \
        --with-filename --line-number
      then
        echo 'error: unexpected "$"'
        exit 1
      fi
    ) &>/dev/stderr

    runHook postInstallCheck
  '';

  passthru.tests = {
    # Build the package and run `dotnet test`
    app = finalAttrs.finalPackage.overrideAttrs {
      pname = "${finalAttrs.pname}-tested";
      doCheck = true;
    };
  };

  passthru.updateScript = nix-update-script { };

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

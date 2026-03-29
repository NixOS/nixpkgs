{
  lib,
  openssl,
  git,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  testers,
}:
buildDotnetModule (finalAttrs: {
  pname = "recyclarr";
  version = "8.5.1";

  src = fetchFromGitHub {
    owner = "recyclarr";
    repo = "recyclarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q2WEa28TYmmg2KDTIsT7AHQC5o0YwpOw+zmepvhoLaI=";
  };

  projectFile = "Recyclarr.slnx";
  nugetDeps = ./deps.json;

  prePatch = ''
    substituteInPlace src/Recyclarr.Cli/Console/CliSetup.cs \
      --replace-fail '$"v{GitVersionInformation.SemVer} ({GitVersionInformation.FullBuildMetaData})"' '"${finalAttrs.version}-nixpkgs"'
    substituteInPlace src/Recyclarr.Cli/Console/Setup/ProgramInformationDisplayTask.cs \
      --replace-fail 'GitVersionInformation.InformationalVersion' '"${finalAttrs.version}-nixpkgs"'
    substituteInPlace src/Recyclarr.Core/ResourceProviders/Infrastructure/ConfigTemplatesStrategy.cs \
      --replace-fail 'GitVersionInformation.Major' '"${lib.versions.major finalAttrs.version}"'

    sed -i '/dotnet-tools\.json/d' Recyclarr.slnx
    rm .config/dotnet-tools.json
  '';
  patches = [ ./001-Git-Version.patch ];

  enableParallelBuilding = false;

  doCheck = false;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  dotnet-test-sdk = dotnetCorePackages.sdk_10_0;

  executables = [ "recyclarr" ];
  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        git
        openssl
      ]
    }"
  ];

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$(mktemp -d) recyclarr --version";
    };
  };

  meta = {
    description = "Automatically sync TRaSH guides to your Sonarr and Radarr instances";
    homepage = "https://recyclarr.dev/";
    changelog = "https://github.com/recyclarr/recyclarr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      josephst
      aldoborrero
    ];
    mainProgram = "recyclarr";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})

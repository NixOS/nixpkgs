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
  version = "8.7.1";

  src = fetchFromGitHub {
    owner = "recyclarr";
    repo = "recyclarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BPU+Kzx7AJRy1aL4QjcUQeLxGpy2lzUF7YoZY/FQEA4=";
  };

  projectFile = "src/Recyclarr.Cli/Recyclarr.Cli.csproj";
  nugetDeps = ./deps.json;

  postPatch = ''
    cat > src/Recyclarr.Core/GitVersionInformation.g.cs <<'EOF'
    public static class GitVersionInformation
    {
        public static string SemVer => "${finalAttrs.version}";
        public static string FullBuildMetaData => "nixpkgs";
        public static string InformationalVersion => "${finalAttrs.version}+nixpkgs";
        public static int Major => ${lib.versions.major finalAttrs.version};
    }
    EOF

    rm .config/dotnet-tools.json
  '';

  doCheck = false;

  dotnetBuildFlags = [
    "-p:DisableGitVersionTask=true"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

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
      command = ''RECYCLARR_CONFIG_DIR="$TMPDIR/recyclarr" recyclarr --version'';
      version = "v${finalAttrs.version}";
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

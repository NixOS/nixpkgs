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
  version = "8.6.0";

  src = fetchFromGitHub {
    owner = "recyclarr";
    repo = "recyclarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uu6fBKODzKGYA6vSJPw0OV/+bi3y2F/SHfrdd5pdyzs=";
  };

  projectFile = "Recyclarr.slnx";
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
    "/m:1"
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
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
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

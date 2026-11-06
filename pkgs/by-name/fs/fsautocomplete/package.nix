{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  testers,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "fsautocomplete";
  version = "0.86.1";

  src = fetchFromGitHub {
    owner = "ionide";
    repo = "FsAutoComplete";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1dSNnrrzqBcOmzHIkX0GNFDloRwWgZWdcPDRij37QT4=";
  };

  nugetDeps = ./deps.json;

  postPatch = ''
    rm global.json
  '';

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.sdk_10_0;

  projectFile = "src/FsAutoComplete/FsAutoComplete.fsproj";
  executables = [ "fsautocomplete" ];

  useDotnetFromEnv = true;

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Backend service for rich editing or intellisense features for editors";
    mainProgram = "fsautocomplete";
    homepage = "https://github.com/ionide/FsAutoComplete";
    changelog = "https://github.com/ionide/FsAutoComplete/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      gbtb
      mdarocha
    ];
  };
})

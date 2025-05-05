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
  version = "0.77.5";

  src = fetchFromGitHub {
    owner = "fsharp";
    repo = "FsAutoComplete";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rPg4GSnxfWWBn3UzQvraH8iL3zOomvompE9Kyuxj5Z0=";
  };

  nugetDeps = ./deps.json;

  postPatch = ''
    rm global.json

    substituteInPlace src/FsAutoComplete/FsAutoComplete.fsproj \
      --replace-fail TargetFrameworks TargetFramework \
  '';

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.sdk_8_0;

  projectFile = "src/FsAutoComplete/FsAutoComplete.fsproj";
  executables = [ "fsautocomplete" ];

  useDotnetFromEnv = true;

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "FsAutoComplete project (FSAC) provides a backend service for rich editing or intellisense features for editors";
    mainProgram = "fsautocomplete";
    homepage = "https://github.com/fsharp/FsAutoComplete";
    changelog = "https://github.com/fsharp/FsAutoComplete/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      gbtb
      mdarocha
    ];
  };
})

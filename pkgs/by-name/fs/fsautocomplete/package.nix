{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  testers,
}:

buildDotnetModule (finalAttrs: rec {
  pname = "fsautocomplete";
  version = "0.75.0";

  src = fetchFromGitHub {
    owner = "fsharp";
    repo = "FsAutoComplete";
    rev = "v${version}";
    hash = "sha256-+IkoXj7l6a/iPigIVy334XiwQFm/pD63FWpV2r0x84c=";
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

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = with lib; {
    description = "FsAutoComplete project (FSAC) provides a backend service for rich editing or intellisense features for editors";
    mainProgram = "fsautocomplete";
    homepage = "https://github.com/fsharp/FsAutoComplete";
    changelog = "https://github.com/fsharp/FsAutoComplete/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      gbtb
      mdarocha
    ];
  };
})

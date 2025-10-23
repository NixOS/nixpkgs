{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
}:
buildDotnetModule (finalAttrs: {
  pname = "slsk-batchdl";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "fiso64";
    repo = "slsk-batchdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZgNjNdk03jIc/REJMmuc5rZLbibLoy94DJxh7jAJY7g=";
  };

  postPatch = ''
    # .NET 6 is EOL, .NET 8 works fine modulo the trimming flag.
    # See: https://github.com/fiso64/slsk-batchdl/issues/112
    substituteInPlace \
        slsk-batchdl/slsk-batchdl.csproj \
        slsk-batchdl.Tests/slsk-batchdl.Tests.csproj \
        --replace-fail "<TargetFramework>net6.0</TargetFramework>" "<TargetFramework>net8.0</TargetFramework>"
  '';

  projectFile = "slsk-batchdl/slsk-batchdl.csproj";

  # Tests fail to build.
  # See: https://github.com/fiso64/slsk-batchdl/issues/111
  # testProjectFile = "slsk-batchdl.Tests/slsk-batchdl.Tests.csproj";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  nugetDeps = ./deps.json;
  executables = [ "sldl" ];

  dotnetFlags = [
    "--property:PublishSingleFile=true"
    # Note: This breaks Spotify authentication!
    # See: https://github.com/fiso64/slsk-batchdl/issues/112
    # "--property:PublishTrimmed=true"
  ];

  selfContainedBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/fiso64/slsk-batchdl";
    description = "Advanced download tool for Soulseek";
    license = lib.licenses.gpl3Only;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "sldl";
  };
})

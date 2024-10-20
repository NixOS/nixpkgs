{
  buildDotnetModule,
  fetchFromGitHub,
  dotnet-sdk_8,
  dotnet-aspnetcore_8,
  nixosTests,
  lib,
  mediainfo,
  rhash,
}:
buildDotnetModule (finalAttrs: {
  pname = "ShokoServer";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "ShokoAnime";
    repo = "ShokoServer";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-xGdNkuKhfQZkD9Qn1yrOgUaoQGa9R2lxJ9DfauZ6QpI=";
    fetchSubmodules = true;
  };

  dotnet-sdk = dotnet-sdk_8;
  dotnet-runtime = dotnet-aspnetcore_8;
  nugetDeps = ./deps.nix;

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${mediainfo}/bin"
  ];
  runtimeDeps = [ rhash ];

  projectFile = "Shoko.CLI/Shoko.CLI.csproj";
  executables = [ "Shoko.CLI" ];

  passthru.tests.shokoserver = nixosTests.shokoserver;

  meta = {
    homepage = "https://github.com/ShokoAnime/ShokoServer";
    description = "Backend for the Shoko anime management system";
    license = lib.licenses.mit;
    mainProgram = "Shoko.CLI";
    maintainers = [ lib.maintainers.diniamo ];
    inherit (dotnet-sdk_8.meta) platforms;
  };
})

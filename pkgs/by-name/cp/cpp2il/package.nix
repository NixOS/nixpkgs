{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
}:

buildDotnetModule (finalAttrs: {
  pname = "Cpp2IL";
  version = "2022.1.0-pre-release.17";

  src = fetchFromGitHub {
    owner = "SamboyCoding";
    repo = "Cpp2IL";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-1rh62mkphwNVgeNDGaukem/M58gGv7DFvyAMI/QpStI=";
  };

  nugetDeps = ./deps.nix;

  projectFile = "Cpp2IL/Cpp2IL.csproj";

  dotnet-sdk =
    with dotnetCorePackages;
    combinePackages [
      sdk_6_0
      sdk_7_0
      sdk_8_0
    ];

  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  dotnetInstallFlags = [ "-p:TargetFramework=net7.0" ];

  executables = [ "Cpp2IL" ];

  meta = {
    description = "Tool to reverse Unity's IL2CPP toolchain";
    homepage = "https://github.com/SamboyCoding/Cpp2IL";
    license = lib.licenses.mit;
    mainProgram = "Cpp2IL";
    maintainers = with lib.maintainers; [ diadatp ];
    platforms = lib.platforms.unix;
  };
})

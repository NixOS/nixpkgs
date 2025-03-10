{
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
  lib,
}:
buildDotnetModule rec {
  pname = "melonloader-installer";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "LavaGang";
    repo = "MelonLoader.Installer";
    tag = version;
    hash = "sha256-1Tdf2xOGBtSW68fycH6Eal4EF7uN2ZAEVBE9st6ruvg=";
  };

  projectFile = "MelonLoader.Installer/MelonLoader.Installer.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps.json;
  selfContainedBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://melonwiki.xyz";
    mainProgram = "MelonLoader.Installer.Linux";
    description = "Automated installer for MelonLoader, the universal mod-loader for games built in the Unity Engine";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ WillemToorenburgh ];
  };
}

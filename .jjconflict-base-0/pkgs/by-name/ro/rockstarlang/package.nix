{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
}:

buildDotnetModule (finalAttrs: {
  pname = "rockstarlang";
  version = "2.0.30";

  src = fetchFromGitHub {
    owner = "RockstarLang";
    repo = "rockstar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IqdObwJm+TiNnNkDg1cbvDI029RLn9i3hxP+wFW730g=";
  };

  projectFile = "Starship/Rockstar/Rockstar.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.dotnet_9.sdk;

  selfContainedBuild = true;

  executables = "rockstar";

  doInstallCheck = true;
  installCheckPhase = ''
    {
      echo 'Shout "it seems to work"'
      echo 'exit'
    } | $out/bin/rockstar | grep '« "it seems to work"'
  '';

  meta = {
    description = "Esoteric programming language whose syntax is inspired by the lyrics to 80s hard rock and heavy metal songs";
    homepage = "https://codewithrockstar.com";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.pinage404 ];
    mainProgram = "rockstar";
  };
})

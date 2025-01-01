{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:
buildDotnetModule rec {
  pname = "skeditor";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "skeditorteam";
    repo = "skeditor";
    rev = "v${version}";
    hash = "sha256-ojE276nonX52UTjvdKL5mX8dj3MNElqlR1A/c0vT9WE=";
  };

  projectFile = "SkEditor/SkEditor.csproj";
  executables = [ "SkEditor" ];
  nugetDeps = ./nuget-deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "App for editing Skript files";
    homepage = "https://github.com/SkEditorTeam/SkEditor";
    changelog = "https://github.com/SkEditorTeam/SkEditor/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
}

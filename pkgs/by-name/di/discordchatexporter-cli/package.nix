{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, testers
, discordchatexporter-cli
}:

buildDotnetModule rec {
  pname = "discordchatexporter-cli";
  version = "2.43.3";

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    rev = version;
    hash = "sha256-r9bvTgqKQY605BoUlysSz4WJMxn2ibNh3EhoMYCfV3c=";
  };

  projectFile = "DiscordChatExporter.Cli/DiscordChatExporter.Cli.csproj";
  nugetDeps = ./deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  postFixup = ''
    ln -s $out/bin/DiscordChatExporter.Cli $out/bin/discordchatexporter-cli
  '';

  passthru = {
    updateScript = ./updater.sh;
    tests.version = testers.testVersion {
      package = discordchatexporter-cli;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Tool to export Discord chat logs to a file";
    homepage = "https://github.com/Tyrrrz/DiscordChatExporter";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/Tyrrrz/DiscordChatExporter/blob/${version}/Changelog.md";
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "discordchatexporter-cli";
  };
}

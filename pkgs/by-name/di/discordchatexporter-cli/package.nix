{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  testers,
  discordchatexporter-cli,
}:

buildDotnetModule rec {
  pname = "discordchatexporter-cli";
  version = "2.47.2";

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    rev = version;
    hash = "sha256-2Sft+8K74vVTpNEgAJ0Y13pn+KiTUdd/5prR1aT6ET4=";
  };

  projectFile = "DiscordChatExporter.Cli/DiscordChatExporter.Cli.csproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  dotnetBuildFlags = [
    # workaround for https://github.com/belav/csharpier/pull/1696
    # remove when csharpier is updated
    "-p:FirstTargetFrameworks=workaround-for-csharpier-pr-1696"
  ];

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

  meta = {
    description = "Tool to export Discord chat logs to a file";
    homepage = "https://github.com/Tyrrrz/DiscordChatExporter";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/Tyrrrz/DiscordChatExporter/releases/tag/${version}";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "discordchatexporter-cli";
  };
}

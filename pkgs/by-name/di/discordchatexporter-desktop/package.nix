{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  testers,
  discordchatexporter-desktop,
}:

buildDotnetModule rec {
  pname = "discordchatexporter-desktop";
  version = "2.44";

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    rev = version;
    hash = "sha256-eLwSodbEux8pYXNZZg8c2rCYowTEkvPzYbxANYe0O7w=";
  };

  env.XDG_CONFIG_HOME = "$HOME/.config";

  projectFile = "DiscordChatExporter.Gui/DiscordChatExporter.Gui.csproj";
  nugetDeps = ./deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  patches = [ ./settings-path.patch ];

  postFixup = ''
    ln -s $out/bin/DiscordChatExporter $out/bin/discordchatexporter
  '';

  passthru = {
    updateScript = ./updater.sh;
  };

  meta = with lib; {
    description = "Tool to export Discord chat logs to a file (GUI version)";
    homepage = "https://github.com/Tyrrrz/DiscordChatExporter";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/Tyrrrz/DiscordChatExporter/blob/${version}/Changelog.md";
    maintainers = with maintainers; [ kekschen ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "discordchatexporter";
  };
}

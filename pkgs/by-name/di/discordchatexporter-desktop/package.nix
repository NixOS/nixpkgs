{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

buildDotnetModule (finalAttrs: {
  pname = "discordchatexporter-desktop";
  version = "2.47.3";

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    tag = finalAttrs.version;
    hash = "sha256-B/2krGBYp/6qgINRyX/38tHlEy9JxmQMAIPsDNjZF5k=";
  };

  env.XDG_CONFIG_HOME = "$HOME/.config";

  projectFile = "DiscordChatExporter.Gui/DiscordChatExporter.Gui.csproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  patches = [ ./settings-path.patch ];

  postFixup = ''
    ln -s $out/bin/DiscordChatExporter $out/bin/discordchatexporter
  '';

  passthru.updateScript = ./updater.sh;

  meta = {
    changelog = "https://github.com/Tyrrrz/DiscordChatExporter/releases/tag/${finalAttrs.version}";
    description = "Tool to export Discord chat logs to a file (GUI version)";
    homepage = "https://github.com/Tyrrrz/DiscordChatExporter";
    license = lib.licenses.gpl3Plus;
    mainProgram = "discordchatexporter";
    maintainers = with lib.maintainers; [
      phanirithvij
      willow
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})

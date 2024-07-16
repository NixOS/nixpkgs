{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, versionCheckHook
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = ./updater.sh;
  };

  meta = with lib; {
    description = "Tool to export Discord chat logs to a file";
    homepage = "https://github.com/Tyrrrz/DiscordChatExporter";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/Tyrrrz/DiscordChatExporter/blob/${version}/Changelog.md";
    maintainers = with maintainers; [ eclairevoyant ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "discordchatexporter-cli";
  };
}

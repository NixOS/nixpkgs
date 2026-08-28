{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  versionCheckHook,
}:

buildDotnetModule (finalAttrs: {
  pname = "discordchatexporter-cli";
  version = "2.48";

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    tag = finalAttrs.version;
    hash = "sha256-8t9T5H2ELoduvvHpxhNbVkjlx18T4dG7Vtuj935ysAo=";
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = ./updater.sh;

  meta = {
    changelog = "https://github.com/Tyrrrz/DiscordChatExporter/releases/tag/${finalAttrs.version}";
    description = "Tool to export Discord chat logs to a file";
    homepage = "https://github.com/Tyrrrz/DiscordChatExporter";
    license = lib.licenses.gpl3Plus;
    mainProgram = "discordchatexporter-cli";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  copyDesktopItems,
  desktopToDarwinBundle,
  makeDesktopItem,
  makeBinaryWrapper,
  gitUpdater,
  _experimental-update-script-combinators,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  libice,
  libsm,
}:

buildDotnetModule (finalAttrs: {
  pname = "discordchatexporter-desktop";
  version = "2.48";

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    tag = finalAttrs.version;
    hash = "sha256-8t9T5H2ELoduvvHpxhNbVkjlx18T4dG7Vtuj935ysAo=";
  };

  env.XDG_CONFIG_HOME = "$HOME/.config";

  projectFile = "DiscordChatExporter.Gui/DiscordChatExporter.Gui.csproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  dotnetBuildFlags = [
    "-p:CSharpier_Bypass=true"
    "-p:FirstTargetFrameworks=workaround-for-csharpier-pr-1696"
  ];

  executables = [ "DiscordChatExporter" ];

  postPatch = ''
    substituteInPlace DiscordChatExporter.Gui/StartOptions.cs \
      --replace-fail 'AppContext.BaseDirectory' 'Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "discordchatexporter")'
  '';

  nativeBuildInputs = [
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
    makeBinaryWrapper
  ];

  runtimeDeps = lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libx11
    libxcursor
    libxext
    libxi
    libxrandr
    libice
    libsm
  ];

  postInstall = ''
    install -Dm444 $src/favicon.png \
      $out/share/icons/hicolor/256x256/apps/discordchatexporter.png
  '';

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      ln -sf $out/bin/DiscordChatExporter $out/bin/discordchatexporter
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      rm $out/Applications/DiscordChatExporter.app/Contents/MacOS/DiscordChatExporter
      makeBinaryWrapper $out/bin/DiscordChatExporter $out/Applications/DiscordChatExporter.app/Contents/MacOS/DiscordChatExporter
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "discordchatexporter";
      desktopName = "DiscordChatExporter";
      comment = finalAttrs.meta.description;
      exec = "DiscordChatExporter";
      icon = "discordchatexporter";
      categories = [
        "Network"
        "Chat"
      ];
    })
  ];

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { }).command
      (finalAttrs.passthru.fetch-deps)
    ];
  };

  meta = {
    changelog = "https://github.com/Tyrrrz/DiscordChatExporter/releases/tag/${finalAttrs.version}";
    description = "Tool to export Discord chat logs to a file (GUI version)";
    homepage = "https://github.com/Tyrrrz/DiscordChatExporter";
    license = lib.licenses.gpl3Plus;
    mainProgram = "discordchatexporter";
    maintainers = with lib.maintainers; [
      phanirithvij
      willow
      philocalyst
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

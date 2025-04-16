{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "1.8.24285.1";
in
buildDotnetModule {
  pname = "qbittorrent-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "fedarovich";
    repo = "qbittorrent-cli";
    tag = "v${version}";
    hash = "sha256-ZGK8nicaXlDIShACeF4QS0BOCZCN0T4JFtHuuFoXhBw=";
  };

  nugetDeps = ./deps.json;
  dotnetBuildFlags = [
    "-f"
    "net6"
  ];
  dotnetInstallFlags = [
    "-f"
    "net6"
  ];
  selfContainedBuild = true;

  projectFile = "src/QBittorrent.CommandLineInterface/QBittorrent.CommandLineInterface.csproj";
  executables = [ "qbt" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgram = "${placeholder "out"}/bin/qbt";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line interface for qBittorrent";
    homepage = "https://github.com/fedarovich/qbittorrent-cli";
    changelog = "https://github.com/fedarovich/qbittorrent-cli/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
    ];
    platforms = lib.platforms.unix;
    badPlatforms = [
      # error NETSDK1084: There is no application host available for the specified RuntimeIdentifier 'osx-arm64'
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      pta2002
    ];
    mainProgram = "qbt";
  };
}

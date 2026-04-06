{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  chromium,
  versionCheckHook,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "patreon-downloader";
  version = "32";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "AlexCSDev";
    repo = "PatreonDownloader";
    tag = "release_${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-1/LAN06DAFTp3RwRMG8WUGMORzsCgoXeiTCFkiLtmRM=";
  };

  patches = [
    # look for plugins and credential data in cwd instead of the installation dir
    ./writable-path.patch

    # use chromium from PATH
    ./chromium.patch
  ];

  projectFile = "PatreonDownloader.App/PatreonDownloader.App.csproj";
  nugetDeps = ./deps.json;
  dotnet-sdk =
    with dotnetCorePackages;
    sdk_10_0
    // {
      inherit (sdk_9_0)
        packages
        targetPackages
        ;
    };
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  dontDotnetFixup = true;
  makeWrapperArgs = [
    "--run"
    ''
      dir="''${XDG_DATA_HOME:-$HOME/.local/share}/PatreonDownloader"
      if mkdir -p "$dir"; then cd "$dir"; fi
    ''
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ chromium ])
  ];
  preFixup = "wrapDotnetProgram $out/lib/patreon-downloader/PatreonDownloader.App $out/bin/PatreonDownloader";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=release_(.*)" ]; };

  meta = {
    description = "Download contents posted by creators on patreon.com";
    homepage = "https://github.com/AlexCSDev/PatreonDownloader";
    changelog = "https://github.com/AlexCSDev/PatreonDownloader/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.unix;
    mainProgram = "PatreonDownloader";
  };
})

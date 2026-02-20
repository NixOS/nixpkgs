{
  enableArchLinuxPkgs ? false,
  enableDnfPackages ? false,
  enable1password ? false,
  enableBitwarden ? true,
  enableBluetooth ? true,
  enableBookmarks ? true,
  enableCalc ? true,
  enableClipboard ? true,
  enableDesktopApplications ? true,
  enableFiles ? true,
  enableMenus ? true,
  enableNiriActions ? true,
  enableNiriSessions ? true,
  enableProviderList ? true,
  enableRunner ? true,
  enableSnippets ? true,
  enableSymbols ? true,
  enableTodo ? true,
  enableUnicode ? true,
  enableWebsearch ? true,
  enableWindows ? true,

  bluez,
  buildGoModule,
  fd,
  fetchFromGitHub,
  imagemagick,
  lib,
  libqalculate,
  makeWrapper,
  nix-update-script,
  protobuf,
  protoc-gen-go,
  wl-clipboard,
}:
let
  providerMap = {
    "1password" = enable1password;
    "archlinuxpkgs" = enableArchLinuxPkgs;
    "bitwarden" = enableBitwarden;
    "bluetooth" = enableBluetooth;
    "bookmarks" = enableBookmarks;
    "calc" = enableCalc;
    "clipboard" = enableClipboard;
    "desktopapplications" = enableDesktopApplications;
    "dnfpackages" = enableDnfPackages;
    "files" = enableFiles;
    "menus" = enableMenus;
    "niriactions" = enableNiriActions;
    "nirisessions" = enableNiriSessions;
    "providerlist" = enableProviderList;
    "runner" = enableRunner;
    "snippets" = enableSnippets;
    "symbols" = enableSymbols;
    "todo" = enableTodo;
    "unicode" = enableUnicode;
    "websearch" = enableWebsearch;
    "windows" = enableWindows;
  };

  enabledProviders = lib.filterAttrs (_: enabled: enabled) providerMap;
  enabledProvidersList = lib.concatStringsSep " " (lib.attrNames enabledProviders);

  runtimeDeps =
    lib.optionals enableFiles [ fd ]
    ++ lib.optionals enableBluetooth [ bluez ]
    ++ lib.optionals enableCalc [ libqalculate ]
    ++ lib.optionals enableClipboard [
      wl-clipboard
      imagemagick
    ];

in
buildGoModule (finalAttrs: {
  pname = "elephant";
  version = "2.19.3";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "elephant";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IyHoHbhLFuIgFG+n7dqHwJaXuNnRaEsxCfAsfudV1KY=";
  };

  vendorHash = "sha256-tO+5x2FIY1UBvWl9x3ZSpHwTWUlw1VNDTi9+2uY7xdU=";

  buildInputs = [ protobuf ];
  nativeBuildInputs = [
    makeWrapper
    protoc-gen-go
  ];

  subPackages = [ "cmd/elephant" ];

  postBuild = ''
    echo "Building providers: ${enabledProvidersList}"

    mkdir -p $out/lib/elephant/providers
    for provider in ${enabledProvidersList}; do
      [ -z "$provider" ] && continue
      if [ -d "internal/providers/$provider" ]; then
        echo "Building provider: $provider"
        go build -buildmode=plugin -o "$out/lib/elephant/providers/$provider.so" ./internal/providers/"$provider" || exit 1
      fi
    done
  '';

  postInstall = ''
    wrapProgram $out/bin/elephant \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set ELEPHANT_PROVIDER_DIR "$out/lib/elephant/providers"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Data provider service and backend for building custom application launchers";
    changelog = "https://github.com/abenz1267/elephant/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/abenz1267/elephant";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      adamcstephens
      saadndm
    ];
    mainProgram = "elephant";
  };
})

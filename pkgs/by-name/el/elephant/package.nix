{
  lib,
  stdenv,
  buildGo125Module,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  protoc-gen-go,
  protobuf,
  fd,
  bluez,
  imagemagick,
  libqalculate,
  wl-clipboard,
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
}:
let
  version = "2.19.1";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "elephant";
    rev = "v${version}";
    hash = "sha256-Ka1uvhSq66yp0IlNFFpx7h+NlysbN52/yUbQKvI4AiA=";
  };

  vendorHash = "sha256-tO+5x2FIY1UBvWl9x3ZSpHwTWUlw1VNDTi9+2uY7xdU=";

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

  unwrapped = buildGo125Module {
    pname = "elephant-unwrapped";
    inherit version src vendorHash;

    buildInputs = [ protobuf ];
    nativeBuildInputs = [
      protoc-gen-go
    ];

    subPackages = [ "cmd/elephant" ];
  };

  providers = buildGo125Module {
    pname = "elephant-providers";
    inherit
      version
      src
      vendorHash
      enabledProvidersList
      ;

    buildInputs = [ protobuf ];
    nativeBuildInputs = [ protoc-gen-go ];

    buildPhase = ''
      runHook preBuild

      echo "Building providers: $enabledProvidersList"

      for provider in $enabledProvidersList; do
        [ -z "$provider" ] && continue
        if [ -d "internal/providers/$provider" ]; then
          echo "Building provider: $provider"
          go build -buildmode=plugin -o "$provider.so" ./internal/providers/"$provider" || exit 1
        fi
      done

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/elephant/providers
      for so_file in *.so; do
        [ -f "$so_file" ] && cp "$so_file" "$out/lib/elephant/providers/"
      done

      runHook postInstall
    '';
  };
in
stdenv.mkDerivation {
  pname = "elephant";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/elephant
    install -Dm755 ${unwrapped}/bin/elephant $out/bin/elephant
    cp -r ${providers}/lib/elephant/providers $out/lib/elephant/

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/elephant \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set ELEPHANT_PROVIDER_DIR "$out/lib/elephant/providers"
  '';

  passthru = {
    inherit unwrapped providers;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Data provider service and backend for building custom application launchers";
    homepage = "https://github.com/abenz1267/elephant";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      saadndm
    ];
    mainProgram = "elephant";
  };
}

{
  lib,
  stdenv,
  config,
  writeText,
  buildDotnetModule,
  fetchFromGitHub,
  fetchpatch,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  imagemagick,
  file,
  libbass,
  libbass_fx,
  SDL2,
  libgdiplus,
  openal,
}:

let
  version = "1.6.0";
in
buildDotnetModule {
  pname = "quaver";
  inherit version;

  src = fetchFromGitHub {
    owner = "Quaver";
    repo = "Quaver";
    tag = version;
    # cannot use fetchSubmodules = true because the optional submodule Quaver.Server.Client is a private repo
    postCheckout = ''
      git -C $out submodule update --init --recursive --checkout -j ''${NIX_BUILD_CORES:-1} --progress --depth 1 -- \
        Quaver.API Quaver.Dependencies Quaver.Resources Wobble
    '';
    hash = "sha256-vGPwck/QwcE3XMf+FTnHnz3dA0ZUEm5s6TqyckopSGI=";
  };

  patches = [
    # Put data in a writable location (~/.local/share) instead of the installation directory
    # https://github.com/Quaver/Wobble/pull/171
    ./writable-path.patch

    # Tell Steamworks API the app id by steam_appid.txt
    ./steam-appid.patch
  ];

  postPatch = ''
    # .NET 6 is EOL
    substituteInPlace Quaver/Quaver.csproj Quaver.API/Quaver.API.Tests/Quaver.API.Tests.csproj \
      Quaver.API/Quaver.Tools/Quaver.Tools.csproj Quaver.Shared/Quaver.Shared.csproj \
      --replace-fail '>net6.0<' '>net8.0<'

    # Have to set this because we set versionsForDotnet="" in preBuild
    # See also https://github.com/Quaver/Quaver/blob/1.6.0/Quaver.Shared/QuaverGame.cs#L175-L188
    substituteInPlace Quaver/Quaver.csproj --replace-fail '<Version>0.0.0</Version>' '<Version>${version}</Version>'
  '';

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    file
  ];

  projectFile = "Quaver/Quaver.csproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  preBuild = ''
    # Otherwise the assembly version of MonoGame.Framework.dll will be incorrect.
    versionForDotnet=
  '';

  executables = [ "Quaver" ];

  # https://github.com/Quaver/Wobble/tree/cce4f3ee2b77b3a2e4b6aff7e6c57210343f74d5/Wobble/x64
  runtimeDeps = [
    libbass
    libbass_fx
    SDL2
    libgdiplus
    openal
  ];

  postInstall = ''
    # The game tries to copy the native blobs to the installation directory.
    # Deleting those blobs prevents this, but the directories must be left in place to prevent the game from crashing.
    # https://github.com/Quaver/Wobble/blob/cce4f3ee2b77b3a2e4b6aff7e6c57210343f74d5/Wobble/Platform/NativeAssemblies.cs
    rm $out/lib/quaver/{x64,x86}/*
    touch $out/lib/quaver/{,x64/,x86/}.keep

    for dll in $out/lib/quaver/*.dll; do
      if ! grep -q 'Mono/.Net assembly' <(file $dll); then
        rm $dll
      fi
    done
    rm $out/lib/quaver/*.${if stdenv.hostPlatform.isDarwin then "so" else "dylib"}

    for size in 16 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${size}x$size/apps
      magick Quaver/Icon.bmp -background none -gravity center \
        -extent "%[fx:w>h?w:h]x%[fx:w>h?w:h]" -resize ''${size}x$size \
        $out/share/icons/hicolor/''${size}x$size/apps/quaver.png
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "quaver";
      exec = "Quaver %U";
      comment = "Community-driven and open-source competitive vertical scrolling rhythm game";
      icon = "quaver";
      desktopName = "Quaver";
      categories = [
        "Game"
        "Music"
      ];
      mimeTypes = [ "x-scheme-handler/quaver" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "community-driven and open-source competitive vertical scrolling rhythm game with two game modes and online leaderboards";
    homepage = "https://quavergame.com";
    changelog = "https://github.com/Quaver/Quaver/releases/tag/${version}";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "Quaver";
  };
}

{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  zlib,
  icu,
  openssl,
  icoutils,
  copyDesktopItems,
  makeDesktopItem,
  writeScript,
}:
buildDotnetModule rec {
  pname = "lumafly";
  version = "3.3.0.0";

  src = fetchFromGitHub {
    owner = "TheMulhima";
    repo = "lumafly";
    rev = "refs/tags/v${version}";
    hash = "sha256-GVPMAwxbq9XlKjMKd9G5yUol42f+6lSyHukN7NMCVDA=";
  };

  # Use .NET 9.0 since 7.0 is EOL
  dotnetFlags = [ "-p:TargetFramework=net9.0" ];

  projectFile = "Lumafly/Lumafly.csproj";

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.sdk_9_0;

  selfContainedBuild = true;

  passthru.updateScript = writeScript "update-lumafly" ''
    #!/usr/bin/env nix-shell
    #!nix-shell --pure -i bash -p bash nix nix-update git cacert
    set -eo pipefail

    prev_version=$(nix eval --raw -f. lumafly.version)
    nix-update lumafly
    [[ $(nix eval --raw -f. lumafly.version) == "$prev_version" ]] ||
      $(nix-build . -A lumafly.fetch-deps --no-out-link)
  '';

  runtimeDeps = [
    zlib
    icu
    openssl
  ];

  nativeBuildInputs = [
    icoutils
    copyDesktopItems
  ];

  executables = [ "Lumafly" ];

  postFixup = ''
    # Icon for the desktop file
    icotool -x $src/Lumafly/Assets/Lumafly.ico
    install -D Lumafly_1_32x32x32.png $out/share/icons/hicolor/32x32/apps/lumafly.png
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Lumafly";
      name = "lumafly";
      exec = "Lumafly";
      icon = "lumafly";
      comment = "A cross platform mod manager for Hollow Knight written in Avalonia";
      type = "Application";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "A cross platform mod manager for Hollow Knight written in Avalonia";
    homepage = "https://themulhima.github.io/Lumafly/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Lumafly";
    maintainers = with lib.maintainers; [ rohanssrao ];
    platforms = lib.platforms.linux;
  };
}

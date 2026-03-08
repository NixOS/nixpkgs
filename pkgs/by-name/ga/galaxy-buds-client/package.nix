{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  fontconfig,
  glib,
  libglvnd,
  libxinerama,
  libxkbcommon,
  libxt,
  libxtst,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "galaxy-buds-client";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "ThePBone";
    repo = "GalaxyBudsClient";
    tag = version;
    hash = "sha256-rFaI5coTGuWoxM3QZyCBJdvwvR6LeB2jjvcJ3xXw5X8=";
  };

  projectFile = [ "GalaxyBudsClient/GalaxyBudsClient.csproj" ];
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  dotnetFlags =
    lib.optionals stdenv.hostPlatform.isx86_64 [ "-p:Runtimeidentifier=linux-x64" ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "-p:Runtimeidentifier=linux-arm64" ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    fontconfig
  ];

  runtimeDeps = [
    libglvnd
    libxinerama
    libxkbcommon
    libxt
    libxtst
  ];

  postFixup = ''
    wrapProgram "$out/bin/GalaxyBudsClient" \
      --prefix PATH : ${glib.bin}/bin

    mkdir -p $out/share/icons/hicolor/256x256/apps/
    cp -r $src/GalaxyBudsClient/Resources/icon.png $out/share/icons/hicolor/256x256/apps/${meta.mainProgram}.png

    # remove wrongly created wrapper for shared objects
    rm $out/bin/*.so
  '';

  desktopItems = [
    (makeDesktopItem {
      name = meta.mainProgram;
      exec = meta.mainProgram;
      icon = meta.mainProgram;
      desktopName = meta.mainProgram;
      genericName = "Galaxy Buds Client";
      comment = meta.description;
      type = "Application";
      categories = [ "Settings" ];
      startupNotify = true;
    })
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Unofficial Galaxy Buds Manager";
    homepage = "https://github.com/ThePBone/GalaxyBudsClient";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ icy-thought ];
    platforms = lib.platforms.linux;
    mainProgram = "GalaxyBudsClient";
  };
}

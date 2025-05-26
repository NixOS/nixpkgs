{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  fontconfig,
  glib,
  libglvnd,
  xorg,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "galaxy-buds-client";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "ThePBone";
    repo = "GalaxyBudsClient";
    tag = version;
    hash = "sha256-ygxrtRapduvK7qAHZzdHnCijm8mcqOviMl2ddf9ge+Y=";
  };

  projectFile = [ "GalaxyBudsClient/GalaxyBudsClient.csproj" ];
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
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
    xorg.libSM
    xorg.libICE
    xorg.libX11
  ];

  postFixup = ''
    wrapProgram "$out/bin/GalaxyBudsClient" \
      --prefix PATH : ${glib.bin}/bin

    mkdir -p $out/share/icons/hicolor/256x256/apps/
    cp -r $src/GalaxyBudsClient/Resources/icon.png $out/share/icons/hicolor/256x256/apps/${meta.mainProgram}.png
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

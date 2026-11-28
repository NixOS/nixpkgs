{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  zlib,
  libGL,
  icu,
  openssl,
  icoutils,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  unzip,
  python3,
}:

buildDotnetModule (finalAttrs: {
  pname = "lumafly";
  version = "3.3.0.0-unstable-2026-10-15";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "TheMulhima";
    repo = "lumafly";
    rev = "9765dd7b70b5e49136e60f817f00a45a08d337a8";
    hash = "sha256-9PD0/mV7sJoN224QOE08Jzf0eEfZ/Tavh01B5UAEHCo=";
  };

  patches = [ ./no_timestamp_check.patch ];

  projectFile = "Lumafly/Lumafly.csproj";
  testProjectFile = "Lumafly.Tests/Lumafly.Tests.csproj";

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  selfContainedBuild = true;

  runtimeDeps = [
    zlib
    icu
    openssl
    libGL
  ];

  nativeBuildInputs = [
    icoutils
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    python3
    unzip
  ];

  executables = [ "Lumafly" ];

  __darwinAllowLocalNetworking = true;
  doCheck = true;

  dotnetTestFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--environment"
    "DOTNET_SYSTEM_NET_DISABLEIPV6=1"
  ];

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export CFFIXED_USER_HOME="$HOME"
  '';

  postInstall = ''
    icotool -x Lumafly/Assets/Lumafly.ico
    install -Dm644 Lumafly_1_32x32x32.png $out/share/icons/hicolor/32x32/apps/lumafly.png
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    (
      cd Scripts
      python3 make_mac_app.py Lumafly.app $out/lib/${finalAttrs.pname} ../out
    )
    mkdir -p $out/Applications
    unzip -o out/mac.zip -d $out/Applications
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Lumafly";
      name = "lumafly";
      exec = "Lumafly %U";
      icon = "lumafly";
      comment = "Cross platform mod manager for Hollow Knight written in Avalonia";
      type = "Application";
      categories = [ "Game" ];
      mimeTypes = [ "x-scheme-handler/scarab" ];
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Cross platform mod manager for Hollow Knight written in Avalonia";
    homepage = "https://themulhima.github.io/Lumafly/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Lumafly";
    maintainers = with lib.maintainers; [ rohanssrao ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})

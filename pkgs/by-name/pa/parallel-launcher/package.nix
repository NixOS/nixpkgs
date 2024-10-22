{
  lib,
  stdenv,
  fetchFromGitLab,

  qt5,
  SDL2,
  discord-rpc,
  libgcrypt,
  sqlite,
  boost,
  darwin,
}:
let
  version = "7.7.0";
  versionParts = lib.splitVersion version;
  # Converts a version string like x.y.z to vx.y-z
  rev = "v${lib.concatStringsSep "." (lib.init versionParts)}-${lib.last versionParts}";
in
stdenv.mkDerivation {
  pname = "parallel-launcher";
  inherit version;

  src = fetchFromGitLab {
    owner = "parallel-launcher";
    repo = "parallel-launcher";
    inherit rev;
    hash = "sha256-snghHMzsBZHH3KvT1EoibbzcLlrGgeK4UwVtaedeX1M=";
  };

  nativeBuildInputs = with qt5; [
    wrapQtAppsHook
    qttools
    qmake
  ];

  buildInputs =
    [
      SDL2
      discord-rpc
      libgcrypt
      sqlite
      qt5.qtbase
      qt5.qtsvg
    ]
    ++ lib.optionals stdenv.isDarwin [
      boost
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.IOKit
    ];

  # The Flatpak version disallows Parallel Launcher from downloading RetroArch by itself
  qmakeFlags = [ "CONFIG+=flatpak-version" ];

  installPhase = ''
    runHook preInstall

    # Taken from pkg/arch/PKGBUILD
    install -D parallel-launcher -t $out/bin/
    install -D ca.parallel_launcher.ParallelLauncher.desktop -t $out/share/applications/
    install -D ca.parallel_launcher.ParallelLauncher.metainfo.xml -t $out/share/metainfo/
    install -D data/appicon.svg $out/share/icons/hicolor/scalable/apps/ca.parallel_launcher.ParallelLauncher.svg
    install -D bps-mime.xml parallel-launcher-{lsjs,sdl-relay} -t $out/share/parallel-launcher/
    install -D lang/* -t $out/share/parallel-launcher/translations/

    runHook postInstall
  '';

  meta = {
    description = "Modern N64 Emulator";
    longDescription = ''
      Parallel Launcher is an emulator launcher that aims to make playing N64 games,
      both retail and homebrew, as simple and as accessible as possible. Parallel
      Launcher uses the RetroArch emulator, but replaces its confusing menus and
      controller setup with a much simpler user interface. It also features optional
      integration with romhacking.com.
    '';
    homepage = "https://parallel-launcher.ca";
    changelog = "https://gitlab.com/parallel-launcher/parallel-launcher/-/releases/${rev}";

    # See pkg/arch/PKGBUILD - only x86_64 is supported
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "x86_64-windows"
    ];

    license = with lib.licenses; [ gpl3Plus ]; # See pkg/deb/copyright
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "parallel-launcher";
  };
}

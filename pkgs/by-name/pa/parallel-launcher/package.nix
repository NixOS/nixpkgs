{
  lib,
  stdenv,
  fetchFromGitLab,
  replaceVars,

  retroarch,
  libretro,
  retroarch-assets,

  qt5,
  SDL2,
  discord-rpc,
  libgcrypt,
  sqlite,
  boost,
  apple-sdk_11,
}:
let
  # Converts a version string like x.y.z to vx.y-z
  reformatVersion = v:
    let
      versionParts = lib.splitVersion v;
    in
    "v${lib.concatStringsSep "." (lib.init versionParts)}-${lib.last versionParts}";

  parallel-n64-next = libretro.parallel-n64.overrideAttrs (final: prev: {
    pname = "libretro-parallel-n64-next";
    version = "2.19.0";

    src = fetchFromGitLab {
      owner = "parallel-launcher";
      repo = "parallel-n64";
      rev = reformatVersion final.version;
      hash = "sha256-I+wYurK27aORCkGY6Yz2aJvOjI8aXTR4F9tN6mLPQ6U=";
    };

    postInstall =
      let
        suffix = stdenv.hostPlatform.extensions.sharedLibrary;
      in
      ''
        (cd $out/lib/retroarch/cores/; mv parallel_n64_libretro${suffix} parallel_n64_next_libretro${suffix})
      '';
  });

  retroarch' = retroarch.override {
    cores = with libretro; [
      mupen64plus
      parallel-n64-next
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "parallel-launcher";
  version = "7.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "parallel-launcher";
    repo = "parallel-launcher";
    rev = reformatVersion finalAttrs.version;
    hash = "sha256-V8YcOuc+HEuyJLbt/95f8HYmz29Hnhx7FRr8fzLTnso=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      coresDir = "${retroarch'}/lib/retroarch/cores";
      assetsDir = "${retroarch-assets}/share/retroarch/assets";
      exePath = lib.getExe retroarch';
    })
  ];

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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      boost
      apple-sdk_11
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
    changelog = "https://gitlab.com/parallel-launcher/parallel-launcher/-/releases/${finalAttrs.src.rev}";

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
})

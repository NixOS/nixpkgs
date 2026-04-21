{
  lib,
  stdenv,
  fetchFromGitHub,
  desktopToDarwinBundle,
  cmake,
  ninja,
  libogg,
  libjpeg,
  libopenmpt,
  libpng,
  libvorbis,
  libmpg123,
  SDL2,
  python3,
  imagemagick,
  libicns,
  nix-update-script,
  pvzDebug ? false, # cheat keys and other debug features
  limboPage ? true, # access to limbo page with hidden minigame levels
  doFixBugs ? false, # fix bugs (which are usually considered features)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pvz-portable-unwrapped";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "wszqkzqk";
    repo = "PvZ-Portable";
    tag = finalAttrs.version;
    hash = "sha256-4CtO62cwNzQ32DE70F8kKFHy7tOsRLpDsgyrBS00C/g=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    imagemagick
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    libogg
    libjpeg
    libopenmpt
    libpng
    libvorbis
    libmpg123
    SDL2
    (python3.withPackages (ps: [ ps.pyyaml ]))
  ];

  cmakeFlags = [
    (lib.cmakeBool "PVZ_DEBUG" pvzDebug)
    (lib.cmakeBool "LIMBO_PAGE" limboPage)
    (lib.cmakeBool "DO_FIX_BUGS" doFixBugs)
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 pvz-portable $out/bin/pvz-portable

    cd .. # exit cmake build dir

    install -Dm755 scripts/pvzp-v4-converter.py $out/bin/pvzp-v4-converter
    install -Dm644 LICENSE $out/share/licenses/pvz-portable/LICENSE
    install -Dm644 COPYING $out/share/licenses/pvz-portable/COPYING

    install -Dm664 archlinux/io.github.wszqkzqk.pvz-portable.desktop $out/share/applications/io.github.wszqkzqk.pvz-portable.desktop
    substituteInPlace $out/share/applications/io.github.wszqkzqk.pvz-portable.desktop --replace-fail /usr/bin/ ""
    install -Dm644 icon.png $out/share/icons/hicolor/512x512/apps/io.github.wszqkzqk.pvz-portable.png
    for size in 16 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/''${size}x$size/apps
      magick icon.png -resize ''${size}x$size $out/share/icons/hicolor/''${size}x$size/apps/io.github.wszqkzqk.pvz-portable.png
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform community-driven reimplementation of Plants vs. Zombies GOTY";
    homepage = "https://github.com/wszqkzqk/PvZ-Portable";
    changelog = "https://github.com/wszqkzqk/PvZ-Portable/releases";
    downloadPage = "https://github.com/wszqkzqk/PvZ-Portable/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      lgpl3Plus
      free # PopCap Games Framework License: redistribution with or without modifications allowed
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.all;
    mainProgram = "pvz-portable";
  };
})

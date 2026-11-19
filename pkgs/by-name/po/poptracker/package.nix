{
  lib,
  stdenv,
  fetchFromGitHub,
  cacert,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  gtest,
  libx11,
  openssl,
  zlib,
  which,
  kdePackages,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,
  meson,
  ninja,
  pkg-config,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "poptracker";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "black-sliver";
    repo = "PopTracker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1zLWY+/qQ8/YH/Ts6HqgyRuQWmW03S1ruxI3ZDtUBtY=";
    fetchSubmodules = true;
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_ttf
    SDL2_image
    libx11
    openssl
    zlib
  ];

  mesonBuildType = "release";

  mesonFlags = [
    # LTO objects in the bundled static liblua are not indexed by the plain `ar` meson uses here
    (lib.mesonBool "auto-lto" false)
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkInputs = [ gtest ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  env.GTEST_FILTER =
    "-"
    + lib.concatStringsSep ":" [
      # Require network access
      "HTTP.SyncGet200"
      "HTTP.GetCached*Redirect"
      # SDL2_image uses the stb_image backend in nixpkgs, which can't load this JPEG and
      # accepts these corrupt PNGs
      "GoodImageFiles/GoodImageFileSuite.*/jpeg_jpg"
      "BadImageFiles/BadImageFileSuite.LoadImage/corrupt1_png"
      "BadImageFiles/BadImageFileSuite.LoadImage/corrupt3_png"
    ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  postInstall = ''
    ln -sf ${cacert}/etc/ssl/certs/ca-bundle.crt $out/share/poptracker/assets/cacert.pem
    wrapProgram $out/bin/poptracker --prefix PATH : ${
      lib.makeBinPath [
        which
        kdePackages.kdialog
      ]
    }
    mkdir -p $out/share/icons/hicolor/{64x64,512x512}/apps
    ln -s $out/share/poptracker/assets/icon.png $out/share/icons/hicolor/64x64/apps/poptracker.png
    ln -s $out/share/poptracker/assets/icon512.png $out/share/icons/hicolor/512x512/apps/poptracker.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "poptracker";
      desktopName = "PopTracker";
      exec = "poptracker";
      comment = "Universal, scriptable randomizer tracking solution";
      icon = "poptracker";
      categories = [
        "Game"
        "Utility"
      ];
    })
  ];

  meta = {
    description = "Scriptable tracker for randomized games";
    longDescription = ''
      Universal, scriptable randomizer tracking solution that is open source. Supports auto-tracking.

      PopTracker packs should be placed in `~/PopTracker/packs` or `./packs`.
    '';
    homepage = "https://github.com/black-sliver/PopTracker";
    changelog = "https://github.com/black-sliver/PopTracker/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      freyacodes
      pyrox0
    ];
    mainProgram = "poptracker";
    platforms = lib.platforms.unix;
  };
})

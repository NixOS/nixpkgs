{
  lib,
  stdenv,
  fetchFromGitHub,
  symlinkJoin,
  requireFile,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  libicns,
  cmake,
  openal,
  curl,
  libogg,
  libvorbis,
  SDL2,
  SDL2_image,
  zlib,
  libtheora,
  boost,
  libGL,
  unfree_assets ? false,
}:

let
  assets = stdenv.mkDerivation {
    pname = "keeperrl-assets";
    version = unwrapped.version;

    # TODO: use fetchItchIo
    src = requireFile rec {
      name = "keeperrl_data_alpha34.tar.gz";
      message = ''
        This nix expression requires that the KeeperRL art assets are already
        part of the store. These can be obtained from a purchased copy of the game
        and found in the "data" directory. Make a tar archive of this directory
        with

        "tar czf ${name} data"

        Then add this archive to the nix store with

        "nix-prefetch-url file://$PWD/${name}".
      '';
      sha256 = "0115pxdzdyma2vicxgr0j21pp82gxdyrlj090s8ihp0b50f0nlll";
      meta.license = lib.licenses.unfree;
    };

    installPhase = ''
      mkdir -p $out/share/keeperrl
      cp -r . $out/share/keeperrl/data
    '';
  };

  unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "keeperrl";
    version = "1.0-hotfix-19";

    src = fetchFromGitHub {
      owner = "miki151";
      repo = "keeperrl";
      tag = lib.replaceStrings [ "." "-" ] [ "_" "_" ] finalAttrs.version;
      postCheckout = ''
        pushd $out
        bash gen_version.sh # uses git to get information to generate version.h
        mv cmake/FindOGG.cmake cmake/FindOgg.cmake # reproducibility on case-insensitive filesystems
        popd
      '';
      hash = "sha256-tD8cu+fbNBkOe/9iRYXMI/6Iqd28WQdL01aWP0hXhKA=";
    };

    __structuredAttrs = true;
    strictDeps = true;

    patches = [
      # Add basic support without steam_api + NDEBUG small fix
      # https://github.com/miki151/keeperrl/pull/2042
      ./fix-no-steamworks.patch
    ];

    postPatch = ''
      rm gen_version.sh # already ran in postCheckout
      rm check_serial.sh # rev: command not found; does not seem to be useful anyway

      substituteInPlace CMakeLists.txt --replace-fail \
        ' -fuse-ld=lld -L /usr/local/lib -Wl,-rpath=. -Wl,--gdb-index' ""
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace mac/keeper-Info.plist \
        --replace-fail '>''${EXECUTABLE_NAME}<' '>keeperrl<' \
        --replace-fail '.''${PRODUCT_NAME:rfc1034identifier}<' '.keeperrl<' \
        --replace-fail '>''${PRODUCT_NAME}<' '>KeeperRL<' \
        --replace-fail $'<key>CFBundleIconFile</key>\n\t<string></string>' $'<key>CFBundleIconFile</key>\n\t<string>keeperrl</string>'
    '';

    buildInputs = [
      openal
      curl
      libogg
      libvorbis
      libtheora
      SDL2
      SDL2_image
      zlib
      libGL
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin boost;

    nativeBuildInputs = [
      cmake
      copyDesktopItems
      makeWrapper
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin libicns;

    env.NIX_CFLAGS_COMPILE = toString (
      [
        "-Wno-missing-template-arg-list-after-template-kw"
        "-DDATA_DIR=\"${placeholder "out"}/share/keeperrl\""
      ]
      ++ lib.optional stdenv.hostPlatform.isDarwin "-DOSX=true"
    );

    enableParallelBuilding = true;

    cmakeFlags = [
      (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
      (lib.cmakeBool "ENABLE_LOCAL_USER_DIR" true)
      (lib.cmakeBool "ENABLE_STEAM" false)
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 keeper $out/bin/keeper

      cd .. # exit cmake build dir
      mkdir -p $out/share/keeperrl
      cp -a appconfig.txt $out/share/keeperrl/appconfig.txt
      cp -ar data_free $out/share/keeperrl
      cp -ar data_contrib $out/share/keeperrl

      mkdir -p $out/share/icons/hicolor/48x48/apps
      ln -s $out/share/keeperrl/data_free/images/icon.png $out/share/icons/hicolor/48x48/apps/keeperrl.png

      runHook postInstall
    '';

    postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications/KeeperRL.app/Contents/{MacOS,Resources}
      ln -s $out/bin/keeper $out/Applications/KeeperRL.app/Contents/MacOS/keeper
      cp mac/keeper-Info.plist $out/Applications/KeeperRL.app/Contents/Info.plist
      png2icns $out/Applications/KeeperRL.app/Contents/Resources/keeperrl.icns data_free/images/icon.png
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "keeperrl";
        comment = finalAttrs.meta.description;
        desktopName = "KeeperRL";
        exec = "keeper";
        icon = "keeperrl";
        categories = [ "Game" ];
      })
    ];

    meta = {
      description = "Dungeon management rogue-like";
      mainProgram = "keeper";
      homepage = "https://keeperrl.com/";
      license = lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [ onny ];
      platforms = lib.platforms.unix;
    };
  });

in
if unfree_assets then
  symlinkJoin (finalAttrs: {
    inherit (finalAttrs.passthru.unwrapped) pname version;
    paths = [
      finalAttrs.passthru.unwrapped
      finalAttrs.passthru.assets
    ];
    passthru = unwrapped.passthru // {
      inherit unwrapped assets;
    };
  })
else
  unwrapped

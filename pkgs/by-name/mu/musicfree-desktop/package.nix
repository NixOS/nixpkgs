{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  nix-update-script,
  electron,
  python3,
  nodejs,
  vips,
  gitMinimal,
  removeReferencesTo,
  xcodebuild,
  zip,
}:

buildNpmPackage (finalAttrs: {
  pname = "musicfree-desktop";
  version = "0.0.8";

  inherit nodejs;

  src = fetchFromGitHub {
    owner = "maotoumao";
    repo = "MusicFreeDesktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gGGlWzd6LRrB5EbkXZWqg2cwMyZ5OMQm6otpnZFUbvo=";
  };

  patches = [
    # update sharp to recognize SHARP_FORCE_GLOBAL_LIBVIPS
    # update node-abi to support newer Electron
    # update nan to fix build with newer Electron (https://github.com/nodejs/nan/issues/921)
    # update better-sqlite3 to fix build with newer Electron
    # see update.sh for how this patch was generated
    ./bump-deps.patch

    # tell electron-packager to look for Electron zips in a local dir
    # instead of downloading them from the internet
    ./electron-zip-dir.patch

    # Do not open devtools on startup.
    # ELECTRON_FORCE_IS_PACKAGED=1 should also do the trick,
    # but it causes weird problem of being unable to look up the resource dir
    ./no-startup-dev-tools.patch
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    (python3.withPackages (ps: [ ps.setuptools ])) # Used by node-gyp
    gitMinimal # Used by electron-forge
    zip
    removeReferencesTo
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcodebuild ]; # Used by better-sqlite3

  npmDepsHash = "sha256-pEpU3JuxeMl0Oo/ZnmzH9/WdJ/3O2RUGofm7KXrKcAo=";

  postConfigure = ''
    # use Electron's headers to make node-gyp compile against the Electron ABI
    export npm_config_nodedir="${electron.headers}"

    # override the detected electron version
    substituteInPlace node_modules/@electron-forge/core-utils/dist/electron-version.js \
      --replace-fail "return version" "return '${electron.version}'"

    # create the electron archive to be used by electron-packager
    # the contents do not matter, but some files must be present, such as a file named "electron" intended to be the executable
    electron_zip=$(pwd)/.electron-packager/electron-zips/electron-v${electron.version}-${stdenv.hostPlatform.node.platform}-${stdenv.hostPlatform.node.arch}.zip
    mkdir -p $(dirname $electron_zip)
    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          for app in Electron.app{,/Contents/Frameworks/Electron\ Helper.app}; do
            mkdir -p "$app/Contents/MacOS"
            cp "${electron.dist}/$app/Contents/Info.plist" "$app/Contents/Info.plist"
            chmod +w "$app/Contents/Info.plist"
            echo dummy > "$app/Contents/MacOS/$(basename "$app" .app)"
          done
          zip -r $electron_zip Electron.app
          rm -r Electron.app
        ''
      else
        ''
          echo dummy > electron
          zip $electron_zip electron
          rm electron
        ''
    }
  '';

  buildInputs = [
    vips # for sharp
  ];

  # sharp tries to write to npm-deps/_libvips when compiling
  makeCacheWritable = true;

  npmBuildScript = "package";

  env = {
    SHARP_FORCE_GLOBAL_LIBVIPS = "1";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    # Have more info in build logs and also prevent the fancy UI of electron-forge spamming the build logs
    DEBUG = "electron-forge:*,electron-packager,@electron/get:*";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "musicfree-desktop";
      desktopName = "MusicFree";
      exec = "MusicFree %U";
      icon = "musicfree-desktop";
      type = "Application";
      comment = finalAttrs.meta.description;
      categories = [ "Utility" ];
      mimeTypes = [ "x-scheme-handler/musicfree" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    # the output of electron-forge is here
    build_dir=$(find out -type d -maxdepth 1 -mindepth 1 | head -n1)
    build_dir=$build_dir/${
      if stdenv.hostPlatform.isDarwin then "MusicFree.app/Contents/Resources" else "resources"
    }

    phome=$out/lib/node_modules/musicfree-desktop
    mkdir -p $(dirname $phome)
    cp -ar $build_dir/app $phome
    cp -ar $build_dir/res $phome
    find $phome/node_modules -type f -executable -exec remove-references-to -t ${nodejs} '{}' \;

    makeWrapper ${lib.getExe electron} $out/bin/MusicFree \
      --add-flags $phome \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    mkdir -p $out/share/pixmaps
    ln -s $phome/res/logo.png $out/share/pixmaps/musicfree-desktop.png

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications/MusicFree.app/Contents/{MacOS,Resources}
      cp $build_dir/../Info.plist $out/Applications/MusicFree.app/Contents
      ln -s $out/bin/MusicFree $out/Applications/MusicFree.app/Contents/MacOS/MusicFree
      ln -s $phome/res/logo.icns $out/Applications/MusicFree.app/Contents/Resources/electron.icns
    ''}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Customizable music player with plugin support";
    homepage = "https://musicfree.catcat.work";
    changelog = "https://github.com/maotoumao/MusicFreeDesktop/blob/${finalAttrs.src.tag}/changelog.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "MusicFree";
    platforms = electron.meta.platforms;
  };
})

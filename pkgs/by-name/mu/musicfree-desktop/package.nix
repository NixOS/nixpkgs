{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron,
  python3,
  nodejs_20,
  vips,
  git,
  removeReferencesTo,
  zip,
}:

let
  # build fails with node 22, reason unclear.
  nodejs = nodejs_20;
in
buildNpmPackage (finalAttrs: {
  pname = "musicfree-desktop";
  version = "0.0.7";

  inherit nodejs;

  src = fetchFromGitHub {
    owner = "maotoumao";
    repo = "MusicFreeDesktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UT71dsRLie7yipRre95OCXTUYOlOMvon8mStV5OYH9Y=";
  };

  patches = [
    # Update sharp to recognize SHARP_FORCE_GLOBAL_LIBVIPS.
    ./bump-deps.patch
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    (python3.withPackages (ps: [ ps.setuptools ])) # Used by node-gyp
    git # Used by electron-forge
    zip
    removeReferencesTo
  ];

  npmDepsHash = "sha256-1EoIItVMAIV1ABDMXQ6iKF9qUh9klBMwSEuIewaB+4k=";

  postConfigure = ''
    # use electron's headers to make node-gyp compile against the electron ABI
    export npm_config_nodedir="${electron.headers}"

    ### override the detected electron version
    substituteInPlace node_modules/@electron-forge/core-utils/dist/electron-version.js \
      --replace-fail "return version" "return '${electron.version}'"

    ### create the electron archive to be used by electron-packager
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd

    rm -r electron-dist

    # Work around known nan issue for electron_33 and above
    # https://github.com/nodejs/nan/issues/978
    substituteInPlace node_modules/nan/nan.h \
      --replace-fail '#include "nan_scriptorigin.h"' ""
  '';

  buildInputs = [
    vips # for sharp
  ];

  makeCacheWritable = true; # sharp tries to write to npm-deps/_libvips when compiling

  npmBuildScript = "package";

  env.SHARP_FORCE_GLOBAL_LIBVIPS = "1";
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  desktopItems = [
    (makeDesktopItem {
      name = "MusicFree";
      desktopName = "MusicFree";
      exec = "musicfree";
      icon = "musicfree";
      type = "Application";
      comment = finalAttrs.meta.description;
      categories = [ "Utility" ];
      mimeTypes = [ "x-scheme-handler/musicfree" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    build_dir=$(find out -type d -maxdepth 1 -mindepth 1 | head -n1)
    phome=$out/lib/musicfree
    mkdir -p $phome
    cp -r $build_dir/{locales,resources} $phome
    find $phome/resources/app/node_modules -type f -executable -exec remove-references-to -t ${nodejs} '{}' \;
    makeWrapper ${lib.getExe electron} $out/bin/musicfree \
      --add-flags $phome/resources/app \
      --argv0 $phome/MusicFree # https://github.com/electron/electron/issues/31121
    ln -s $phome/resources/res/logo.png $out/share/pixmaps/musicfree.png

    runHook postInstall
  '';

  meta = {
    description = "Customizable music player with plugin support";
    homepage = "https://musicfree.catcat.work";
    changelog = "https://github.com/maotoumao/MusicFreeDesktop/blob/master/changelog.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "musicfree";
    platforms = electron.meta.platforms;
  };
})

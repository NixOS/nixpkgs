{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  electron,
  xcodebuild,
  desktopToDarwinBundle,
}:

buildNpmPackage (finalAttrs: {
  pname = "solidtime-desktop";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "solidtime-io";
    repo = "solidtime-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-92w8vmzyQbIbRaQdXKKpeaLdxhLVpxyCE3RJjtJf0Jk=";
  };

  nativeBuildInputs = [
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcodebuild
    desktopToDarwinBundle
  ];

  npmDepsHash = "sha256-EwtCA94ezhq36ooVvQWd4ThtxqWSOe7cr28V1thet2o=";

  # fixes missing npm dependency errors
  patches = [ ./missing-hashes.patch ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  # rebuild better-sqlite3 for nixpkgs electron
  preBuild = ''
    export npm_config_nodedir="${electron.headers}"
    export npm_config_target="${electron.version}"

    npm rebuild --verbose --no-progress --offline

    # reduce better-sqlite3 size
    pushd node_modules/better-sqlite3
    rm -rf src deps build/{deps,Release/{.deps,obj,obj.target,test_extension.node}}
    popd
  '';

  postInstall = ''
    install -Dm644 build/icon.png $out/share/icons/hicolor/1024x1024/apps/solidtime-desktop.png
    cp -r out $out/lib/node_modules/solidtime

    makeWrapper ${lib.getExe electron} $out/bin/solidtime-desktop \
      --add-flags $out/lib/node_modules/solidtime
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "solidtime-desktop";
      exec = "solidtime-desktop %U";
      icon = "solidtime-desktop";
      desktopName = "Solidtime Desktop";
      comment = finalAttrs.meta.description;
      categories = [ "Utility" ];
      mimeTypes = [ "x-scheme-handler/solidtime" ];
      terminal = false;
    })
  ];

  meta = {
    description = "Modern open-source time-tracking app";
    homepage = "https://github.com/solidtime-io/solidtime-desktop";
    changelog = "https://github.com/solidtime-io/solidtime-desktop/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    mainProgram = "solidtime-desktop";
    maintainers = with lib.maintainers; [ hensoko ];
    platforms = lib.platforms.all;
  };
})

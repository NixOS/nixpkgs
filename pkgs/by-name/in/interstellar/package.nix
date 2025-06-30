{
  copyDesktopItems,
  flutter332,
  fetchFromGitHub,
  imagemagick,
  lib,
  libass,
  makeDesktopItem,
  mpv,
}:

flutter332.buildFlutterApplication rec {
  pname = "interstellar";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "interstellar-app";
    repo = "interstellar";
    tag = "v${version}";
    hash = "sha256-osZp2hk9ZoMxto5Sla4vWSWjTFB+syOwlFGTRHJjcVU=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  buildInputs = [
    imagemagick
    libass
    mpv
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  # set version for the app
  # set some files to use dart-3.8.0 as they use null-aware-elements
  # TODO - remove file patches once https://github.com/NixOS/nixpkgs/pull/410532 is merged
  patches = [
    ./version_dart_3p8.patch
  ];

  # temp turn off language locale gen
  postPatch = ''
    substituteInPlace pubspec.yaml --replace-fail "generate: true" "generate: false"
  '';

  # 1 - turn language locale gen back on
  # 2 - tweak the package_config.json to add a languageVersion to the self named entry
  #     json_serializable breaks if the "interstellar" entry does not have a version key.
  #     TODO - improve jq to find the entry with a map() or select() rather than specifying
  #     the last entry with [-1]
  # 3 - run build_runner to make model .part files and language locale gen
  preBuild = ''
    substituteInPlace pubspec.yaml --replace-fail "generate: false" "generate: true"

    cd .dart_tool/
    mv package_config.json orig.package_config.json
    jq '.packages[-1] |= {"name": "interstellar", "rootUri": "../", "packageUri": "lib/", "languageVersion": "3.7"}' orig.package_config.json > package_config.json
    cd ..

    packageRun build_runner build -d
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/interstellar/lib
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "one.jwr.interstellar";
      desktopName = "Interstellar";
      exec = "interstellar";
      icon = "Interstellar";
      categories = [
        "Network"
        "News"
      ];
    })
  ];

  postInstall = ''
    for size in 16 22 24 32 36 48 64 72 96 128 192 256 512 1024; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick $src/assets/icons/logo.png -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/Interstellar.png
    done
  '';

  meta = {
    description = "App for Mbin/Lemmy/PieFed, connecting you to the fediverse";
    homepage = "https://interstellar.jwr.one";
    license = lib.licenses.agpl3Plus;
    mainProgram = "interstellar";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ JollyDevelopment ];
  };
}

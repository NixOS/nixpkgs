{
  copyDesktopItems,
  flutter332,
  fetchFromGitHub,
  imagemagick,
  lib,
  libass,
  makeDesktopItem,
  mpv-unwrapped,
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
    mpv-unwrapped
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  # temp turn off language locale gen
  postPatch = ''
    substituteInPlace pubspec.yaml --replace-fail "generate: true" "generate: false"
  '';

  # 1 - turn language locale gen back on
  # 2 - set the app version (upstream does this in a github runner)
  # 3 - run build_runner to make model .part files and language locale gen
  preBuild = ''
    substituteInPlace pubspec.yaml \
      --replace-fail "generate: false" "generate: true" \
      --replace-fail "version: 0.0.0" "version: ${version}"
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

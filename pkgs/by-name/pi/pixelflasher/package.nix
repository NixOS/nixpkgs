{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook3,
  python3Packages,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "pixelflasher";
  version = "8.5.1.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "badabing2005";
    repo = "PixelFlasher";
    tag = "v${version}";
    hash = "sha256-IAetTEycuOhjZEgfqen+Za4hjgCzYQuEduElWuhZybE=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "PixelFlasher";
      exec = "pixelflasher";
      icon = "pixelflasher";
      desktopName = "PixelFlasher";
      genericName = "Pixel™ phone flashing GUI utility with features";
      categories = [ "Development" ];
    })
  ];

  dependencies = with python3Packages; [
    attrdict
    beautifulsoup4
    bsdiff4
    chardet
    cryptography
    darkdetect
    httplib2
    json5
    lz4
    markdown
    platformdirs
    polib
    protobuf
    psutil
    pyperclip
    requests
    rsa
    six
    wxpython
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    python3Packages.pyinstaller
    copyDesktopItems
  ];

  buildPhase =
    let
      specFile =
        if stdenv.hostPlatform.isDarwin then
          if stdenv.hostPlatform.isAarch64 then "build-on-mac" else "build-on-mac-intel-only"
        else
          "build-on-linux";
    in
    ''
      runHook preBuild

      pyinstaller --clean --noconfirm --log-level=DEBUG ${specFile}.spec

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/icons/hicolor/64x64/apps
    cp dist/PixelFlasher $out/bin/pixelflasher
    cp images/icon-64.png $out/share/icons/hicolor/64x64/apps/pixelflasher.png

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pixel™ phone flashing GUI utility with features";
    homepage = "https://github.com/badabing2005/PixelFlasher";
    changelog = "https://github.com/badabing2005/PixelFlasher/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ cything ];
    mainProgram = "pixelflasher";
    platforms = lib.platforms.linux;
  };
}

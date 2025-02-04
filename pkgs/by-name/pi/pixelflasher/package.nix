{
  android-tools,
  cacert,
  copyDesktopItems,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  nix-update-script,
  python3,
  stdenv,
  substituteAll,
  wrapGAppsHook3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pixelflasher";
  version = "7.9.2.4";

  src = fetchFromGitHub {
    owner = "badabing2005";
    repo = "PixelFlasher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bksTk6Zbj8/4FQ7gUGXfJa+kkJE/bFbJF7A4AY6zIRk=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    python3.pkgs.pyinstaller
    wrapGAppsHook3
  ];

  buildInputs = with python3.pkgs; [
    android-tools
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
    protobuf
    psutil
    pyperclip
    requests
    rsa
    six
    wxpython
  ];

  patchPhase = ''
    # we set the default android-tools path for convenience
    substituteInPlace config.py --replace-fail \
      "platform_tools_path = None" "platform_tools_path = '/run/current-system/sw/bin/'"
  '';

  buildPhase = ''
    sh build.sh
  '';

  installPhase = ''
    runHook preInstall
    install -D dist/PixelFlasher $out/bin/pixelflasher
    install -D images/icon-dark-256.png $out/share/pixmaps/pixelflasher.png
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set REQUESTS_CA_BUNDLE "${cacert}/etc/ssl/certs/ca-bundle.crt"
      --set PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION python
    )
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "PixelFlasher";
      name = "pixelflasher";
      exec = "pixelflasher";
      icon = "pixelflasher";
      categories = [ "Utility" ];
      genericName = finalAttrs.meta.description;
      noDisplay = false;
      startupNotify = true;
      terminal = false;
      type = "Application";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pixel™ phone flashing GUI utility with features";
    homepage = "https://github.com/badabing2005/PixelFlasher";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      cjshearer
      samueltardieu
    ];
    mainProgram = "pixelflasher";
    platforms = lib.platforms.all;
    broken = lib.versionOlder python3.version "3.11" || stdenv.hostPlatform.isDarwin;
  };
})

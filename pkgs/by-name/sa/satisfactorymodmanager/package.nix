{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nodejs_20,
  pnpm_8,
  wails,
  wrapGAppsHook3,
  glib-networking,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  # NodeJS 22.18.0 broke our build, not sure why
  wails' = wails.override { nodejs = nodejs_20; };
in
buildGoModule rec {
  pname = "satisfactorymodmanager";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "satisfactorymodding";
    repo = "SatisfactoryModManager";
    tag = "v${version}";
    hash = "sha256-ndvrgSRblm7pVwnGvxpwtGVMEGp+mqpC4kE87lmt36M=";
  };

  patches = [
    # disable postcss-import-url
    ./dont-vendor-remote-fonts.patch

    # populates the lib/generated directory
    ./add-generated-files.patch
  ];

  postPatch = ''
    # don't generate i18n and graphql code
    substituteInPlace frontend/package.json \
        --replace-fail '"postinstall":' '"_postinstall":'
  '';

  nativeBuildInputs = [
    pnpm_8.configHook
    wails'
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    glib-networking
  ];

  # we use env because buildGoModule doesn't forward all normal attrs
  # this is pretty hacky
  env = {
    pnpmDeps = pnpm_8.fetchDeps {
      inherit pname version src;
      sourceRoot = "${src.name}/frontend";
      fetcherVersion = 1;
      hash = "sha256-OP+3zsNlvqLFwvm2cnBd2bj2Kc3EghQZE3hpotoqqrQ=";
    };

    pnpmRoot = "frontend";
  };

  # running this caches some additional dependencies for the FOD
  overrideModAttrs = {
    preBuild = ''
      wails build -tags webkit2_41 # 4.0 EOL
    '';
  };

  proxyVendor = true;

  vendorHash = "sha256-3nsJPuwL2Zw/yuHvd8rMSpj9DBBpYUaR19z9TSV/7jg=";

  buildPhase = ''
    runHook preBuild
    wails build -tags webkit2_41 # 4.0 EOL
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 build/bin/SatisfactoryModManager -t "$out/bin"

    for i in 16 32 64 128 256 512; do
      install -D ./icons/"$i"x"$i".png "$out"/share/icons/hicolor/"$i"x"$i"/apps/SatisfactoryModManager.png
    done
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "SatisfactoryModManager";
      desktopName = "Satisfactory Mod Manager";
      exec = "SatisfactoryModManager %u";
      mimeTypes = [ "x-scheme-handler/smmanager" ];
      icon = "SatisfactoryModManager";
      terminal = false;
      categories = [ "Game" ];
    })
  ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Mod manager and modloader for Satisfactory";
    homepage = "https://github.com/satisfactorymodding/SatisfactoryModManager";
    license = lib.licenses.gpl3Only;
    mainProgram = "SatisfactoryModManager";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

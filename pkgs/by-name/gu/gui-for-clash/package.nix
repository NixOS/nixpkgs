{
  stdenv,
  nodejs,
  pnpm_9,
  fetchFromGitHub,
  buildGoModule,
  lib,
  wails,
  webkitgtk_4_0,
  pkg-config,
  libsoup_3,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  replaceVars,
}:
let
  pname = "gui-for-clash";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "GUI-for-Cores";
    repo = "GUI.for.Clash";
    tag = "v${version}";
    hash = "sha256-0PNFiOZ+POp1P/HDJmAIMKNGIjft6bfwPiRDLswY2ns=";
  };

  frontend = stdenv.mkDerivation (finalAttrs: {
    inherit pname version src;

    nativeBuildInputs = [
      nodejs
      pnpm_9.configHook
    ];

    pnpmDeps = pnpm_9.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/frontend";
      hash = "sha256-mG8b16PP876EyaX3Sc4WM41Yc/oDGZDiilZPaxPvvuQ=";
    };

    sourceRoot = "${finalAttrs.src.name}/frontend";

    buildPhase = ''
      runHook preBuild

      pnpm run build-only

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r ./dist $out

      runHook postInstall
    '';

    meta = {
      description = "GUI program developed by vue3";
      license = with lib.licenses; [ gpl3Plus ];
      maintainers = with lib.maintainers; [ ];
      platforms = lib.platforms.linux;
    };
  });
in
buildGoModule {
  inherit pname version src;

  patches = [ ./bridge.patch ];

  postPatch = ''
    # As we need the $out reference, we can't use `replaceVars` here.
    substituteInPlace bridge/bridge.go \
      --replace-fail '@basepath@' "$out"
  '';

  vendorHash = "sha256-OrysyJF+lUMf+0vWmOZHjxUdE6fQCKArmpV4alXxtYs=";

  nativeBuildInputs = [
    wails
    pkg-config
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    webkitgtk_4_0
    libsoup_3
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "gui-for-clash";
      exec = "GUI.for.Clash";
      icon = "gui-for-clash";
      genericName = "GUI.for.Clash";
      desktopName = "GUI.for.Clash";
      categories = [
        "Network"
      ];
      keywords = [
        "Proxy"
      ];
    })
  ];

  preBuild = ''
    cp -r ${frontend} ./frontend/dist
  '';

  buildPhase = ''
    runHook preBuild

    wails build -m -s -trimpath -skipbindings -devtools -tags webkit2_40 -o GUI.for.Clash

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 0755 ./build/bin/GUI.for.Clash $out/bin/GUI.for.Clash
    install -Dm 0644 build/appicon.png $out/share/pixmaps/gui-for-clash.png

    runHook postInstall
  '';

  meta = {
    description = "Clash GUI program developed by vue3 + wails";
    homepage = "https://github.com/GUI-for-Cores/GUI.for.Clash";
    mainProgram = "GUI.for.Clash";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}

{
  stdenv,
  nodejs,
  pnpm,
  fetchFromGitHub,
  buildGoModule,
  lib,
  wails,
  webkitgtk_4_0,
  pkg-config,
  libsoup_3,
  wrapGAppsHook3,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  pname = "gui-for-singbox";
  version = "1.8.9";
  src = fetchFromGitHub {
    owner = "GUI-for-Cores";
    repo = "GUI.for.SingBox";
    rev = "v${version}";
    hash = "sha256-mN+j2O/pM+kblmxZjVWvHXLHJSxydxLRh/Fol2+WALE=";
  };
  frontend = stdenv.mkDerivation (finalAttrs: {
    inherit pname version src;

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/frontend";
      hash = "sha256-bAgyGZLmEr8tMunoeQHl+B2IDGr4Gw3by1lC811lqio=";
    };

    sourceRoot = "${finalAttrs.src.name}/frontend";

    buildPhase = ''
      runHook preBuild

      pnpm run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out/
      cp -r ./dist/* $out/

      runHook postInstall
    '';

    meta = {
      description = "GUI program developed by vue3";
      license = with lib.licenses; [ gpl3Plus ];
      maintainers = with lib.maintainers; [ aucub ];
      platforms = lib.platforms.linux;
    };
  });
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-rDbJOj8t/qu04Rd8J0LnXiBoIDmdzBQ9avAhImK7dFg=";

  nativeBuildInputs = [
    wails
    pkg-config
    wrapGAppsHook3
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    webkitgtk_4_0
    libsoup_3
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "GUI.for.SingBox";
      exec = "GUI.for.SingBox";
      icon = "GUI.for.SingBox";
      genericName = "GUI.for.SingBox";
      desktopName = "GUI.for.SingBox";
      categories = [
        "Network"
      ];
      keywords = [
        "Proxy"
      ];
    })
  ];

  postUnpack = ''
    cp -r ${frontend} $sourceRoot/frontend/dist
  '';

  patches = [ ./bridge.patch ];

  buildPhase = ''
    runHook preBuild

    wails build -m -s -trimpath -skipbindings -devtools -tags webkit2_40 -o GUI.for.SingBox

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pixmaps
    cp -r ./build/bin $out/bin
    cp build/appicon.png $out/share/pixmaps/GUI.for.SingBox.png

    runHook postInstall
  '';

  meta = {
    description = "SingBox GUI program developed by vue3 + wails";
    homepage = "https://github.com/GUI-for-Cores/GUI.for.SingBox";
    mainProgram = "GUI.for.SingBox";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}

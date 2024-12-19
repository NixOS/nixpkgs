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
  pname = "gui-for-clash";
  version = "1.8.9";
  src = fetchFromGitHub {
    owner = "GUI-for-Cores";
    repo = "GUI.for.Clash";
    rev = "v${version}";
    hash = "sha256-jNYMv3gPbZV2JlTV0v0NQ06HkXDzgHXuEdJrBgQ+p2g=";
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
      hash = "sha256-RQtU61H1YklCgJrlyHALxUZp8OvVs2MgFThWBsYk2cs=";
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
      name = "GUI.for.Clash";
      exec = "GUI.for.Clash";
      icon = "GUI.for.Clash";
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

  postUnpack = ''
    cp -r ${frontend} $sourceRoot/frontend/dist
  '';

  postPatch = ''
    sed -i '/exePath, err := os.Executable()/,+3d' bridge/bridge.go
    substituteInPlace bridge/bridge.go \
      --replace-fail "Env.BasePath = filepath.Dir(exePath)" "" \
      --replace-fail "Env.AppName = filepath.Base(exePath)" "Env.AppName = \"GUI.for.Clash\"
        Env.BasePath = filepath.Join(os.Getenv(\"HOME\"), \".config\", Env.AppName)" \
      --replace-fail 'exePath := Env.BasePath' 'exePath := "${placeholder "out"}/bin"'
  '';

  buildPhase = ''
    runHook preBuild

    wails build -m -s -trimpath -skipbindings -devtools -tags webkit2_40 -o GUI.for.Clash

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pixmaps
    cp -r ./build/bin $out/bin
    cp build/appicon.png $out/share/pixmaps/GUI.for.Clash.png

    runHook postInstall
  '';

  meta = {
    description = "Clash GUI program developed by vue3 + wails";
    homepage = "https://github.com/GUI-for-Cores/GUI.for.Clash";
    mainProgram = "GUI.for.Clash";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}

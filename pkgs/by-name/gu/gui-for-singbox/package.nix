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
  pname = "gui-for-singbox";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "GUI-for-Cores";
    repo = "GUI.for.SingBox";
    tag = "v${version}";
    hash = "sha256-5zd4CVWVR+E3E097Xjd/V6QFRV9Ye2UQvBalAQ9zqXc=";
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
      hash = "sha256-dLI1YMzs9lLk9lJBkBgc6cpirM79khy0g5VaOVEzUAc=";
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
      name = "gui-for-singbox";
      exec = "GUI.for.SingBox";
      icon = "gui-for-singbox";
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

  preBuild = ''
    cp -r ${frontend} ./frontend/dist
  '';

  buildPhase = ''
    runHook preBuild

    wails build -m -s -trimpath -skipbindings -devtools -tags webkit2_40 -o GUI.for.SingBox

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 0755 ./build/bin/GUI.for.SingBox $out/bin/GUI.for.SingBox
    install -Dm 0644 build/appicon.png $out/share/pixmaps/gui-for-singbox.png

    runHook postInstall
  '';

  meta = {
    description = "SingBox GUI program developed by vue3 + wails";
    homepage = "https://github.com/GUI-for-Cores/GUI.for.SingBox";
    mainProgram = "GUI.for.SingBox";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}

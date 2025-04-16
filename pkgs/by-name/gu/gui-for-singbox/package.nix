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
  nix-update-script,
}:

let
  pname = "gui-for-singbox";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "GUI-for-Cores";
    repo = "GUI.for.SingBox";
    tag = "v${version}";
    hash = "sha256-v6bx1nIIL5SpPsiUNbU35w7vh+1Zgl+d0Y6sG5XfEB8=";
  };

  metaCommon = {
    description = "SingBox GUI program developed by vue3 + wails";
    homepage = "https://github.com/GUI-for-Cores/GUI.for.SingBox";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
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
      hash = "sha256-5SVu8eCyN89k6BvNEqgs4hOrP5IjvjUZrzrVuDwtYCk=";
    };

    sourceRoot = "${finalAttrs.src.name}/frontend";

    buildPhase = ''
      runHook preBuild

      pnpm run build-only

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';

    meta = metaCommon;
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

  vendorHash = "sha256-Zt3We+Ai8oEqof2eQvcaIkocH85goeldmPf4mmDX17o=";

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

  preBuild = ''
    cp -r ${frontend} frontend/dist
  '';

  buildPhase = ''
    runHook preBuild

    wails build -m -s -trimpath -skipbindings -devtools -tags webkit2_40 -o GUI.for.SingBox

    runHook postBuild
  '';

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

  installPhase = ''
    runHook preInstall

    install -Dm 0755 build/bin/GUI.for.SingBox $out/bin/GUI.for.SingBox
    install -Dm 0644 build/appicon.png $out/share/pixmaps/gui-for-singbox.png

    runHook postInstall
  '';

  passthru = {
    inherit frontend;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = metaCommon // {
    mainProgram = "GUI.for.SingBox";
  };
}

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
  pname = "gui-for-clash";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "GUI-for-Cores";
    repo = "GUI.for.Clash";
    tag = "v${version}";
    hash = "sha256-XQbiric4iAxvWRLKCCZtDrpFpPCylQlwnCm9dHSq/KM=";
  };

  metaCommon = {
    homepage = "https://github.com/GUI-for-Cores/GUI.for.Clash";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
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

    meta = metaCommon // {
      description = "GUI program developed by vue3";
      platforms = lib.platforms.all;
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

    wails build -m -s -trimpath -skipbindings -devtools -tags webkit2_40 -o GUI.for.Clash

    runHook postBuild
  '';

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

  installPhase = ''
    runHook preInstall

    install -Dm 0755 build/bin/GUI.for.Clash $out/bin/GUI.for.Clash
    install -Dm 0644 build/appicon.png $out/share/pixmaps/gui-for-clash.png

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
    description = "Clash GUI program developed by vue3 + wails";
    mainProgram = "GUI.for.Clash";
    platforms = lib.platforms.linux;
  };
}

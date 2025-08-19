{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  nodejs,
  pkg-config,
  pnpm_10,
  wails,
  webkitgtk_4_1,
  makeDesktopItem,
  nix-update-script,
}:

let
  pname = "gui-for-singbox";
  version = "1.9.8";

  src = fetchFromGitHub {
    owner = "GUI-for-Cores";
    repo = "GUI.for.SingBox";
    tag = "v${version}";
    hash = "sha256-9Vai/C9cJgqM3n+FzFPXismR5vF6eQNJHdI7o47zinI=";
  };

  metaCommon = {
    homepage = "https://github.com/GUI-for-Cores/GUI.for.SingBox";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
  };

  frontend = stdenv.mkDerivation (finalAttrs: {
    inherit pname version src;

    sourceRoot = "${finalAttrs.src.name}/frontend";

    nativeBuildInputs = [
      nodejs
      pnpm_10.configHook
    ];

    pnpmDeps = pnpm_10.fetchDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      fetcherVersion = 2;
      hash = "sha256-iVD/9uTK3cUzKE20pJk67uk53UCtfj/YCpgwgxmmg8k=";
    };

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

  patches = [ ./xdg-path-and-restart-patch.patch ];

  # As we need the $out reference, we can't use `replaceVars` here.
  postPatch = ''
    substituteInPlace bridge/bridge.go \
      --subst-var out
  '';

  vendorHash = "sha256-7pFjfUFkpXyYEVjiXbfFUC7FQSlZubKJJ5MI8WY0IVA=";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    pkg-config
    wails
  ];

  buildInputs = [ webkitgtk_4_1 ];

  preBuild = ''
    cp -r ${frontend} frontend/dist
  '';

  buildPhase = ''
    runHook preBuild

    wails build -m -s -trimpath -skipbindings -devtools -tags webkit2_41 -o GUI.for.SingBox

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "gui-for-singbox";
      exec = "GUI.for.SingBox";
      icon = "gui-for-singbox";
      genericName = "GUI.for.SingBox";
      desktopName = "GUI.for.SingBox";
      categories = [ "Network" ];
      keywords = [ "Proxy" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 build/bin/GUI.for.SingBox $out/bin/GUI.for.SingBox
    install -Dm 0644 build/appicon.png $out/share/icons/hicolor/256x256/apps/gui-for-singbox.png

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
    description = "SingBox GUI program developed by vue3 + wails";
    mainProgram = "GUI.for.SingBox";
    platforms = lib.platforms.linux;
  };
}

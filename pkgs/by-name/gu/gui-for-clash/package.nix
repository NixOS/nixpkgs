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
  pname = "gui-for-clash";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "GUI-for-Cores";
    repo = "GUI.for.Clash";
    tag = "v${version}";
    hash = "sha256-kk6ZjG58gMIPd8f3Ib+1z7bie9X5kJvBq/CwioksbcU=";
  };

  metaCommon = {
    homepage = "https://github.com/GUI-for-Cores/GUI.for.Clash";
    hydraPlatforms = [ ]; # https://gui-for-cores.github.io/guide/#note
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
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
      hash = "sha256-MvGLIB68itkCGsBIgAI6ak5xa5rFAJfoAwNuISPRw30=";
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

  vendorHash = "sha256-6T9cFVzfRJnwnWjc61oSihifgnP81n3K+jlLHXGmA4I=";

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

    wails build -m -s -trimpath -skipbindings -devtools -tags webkit2_41 -o GUI.for.Clash

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "gui-for-clash";
      exec = "GUI.for.Clash";
      icon = "gui-for-clash";
      genericName = "GUI.for.Clash";
      desktopName = "GUI.for.Clash";
      categories = [ "Network" ];
      keywords = [ "Proxy" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 build/bin/GUI.for.Clash $out/bin/GUI.for.Clash
    install -Dm 0644 build/appicon.png $out/share/icons/hicolor/256x256/apps/gui-for-clash.png

    runHook postInstall
  '';

  passthru = {
    inherit frontend;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v([0-9.]+)$"
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

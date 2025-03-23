{
  autoPatchelfHook,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nodejs,
  npmHooks,
  pkg-config,
  stdenv,
  wails,
  webkitgtk_4_0,
  wrapGAppsHook3,
  electron,
}:
let
  pname = "ask-mai";
  version = "0.15.0";
  src = fetchFromGitHub {
    owner = "rainu";
    repo = "ask-mai";
    tag = "v${version}";
    hash = "sha256-bK5h8ejCmXYzNja7sfrFfkVuF2zZLEbwsL1n9XfE+pc=";
  };
  frontend = stdenv.mkDerivation (finalAttrs: {
    inherit pname version src;

    nativeBuildInputs = [
      nodejs
      npmHooks.npmConfigHook
      electron
    ];

    npmDeps = fetchNpmDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/frontend";
      hash = "sha256-bnC5rJE0CBV8NRbsiM3U+TKiQnJAmP9kyrsxx/nwd78=";
    };

    sourceRoot = "${finalAttrs.src.name}/frontend";
    npmPackFlags = [ "--ignore-scripts" ];
    dontNpmInstall = true;

    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

    buildPhase = ''
      runHook preBuild

      npm run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      npm install --verbose

      mkdir $out/
      cp -r ./dist/* $out/

      runHook postInstall
    '';
  });
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-oFxJ6hhZLI48+YlFE7X8WUZz+nz+9kOtdIEihGFvoaA=";

  nativeBuildInputs = [
    wails
    pkg-config
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_0
  ];

  postUnpack = ''
    cp -r ${frontend} $sourceRoot/frontend/dist
  '';

  buildPhase = ''
    runHook preBuild

    wails build -m -s -trimpath -skipbindings -devtools -tags webkit2_40 -o ask-mai

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./build/bin $out/bin

    runHook postInstall
  '';

  meta = {
    description = "A little UI-Application for asking Gen-AI";
    homepage = "https://github.com/rainu/ask-mai";
    mainProgram = "ask-mai";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ confusedalex ];
    platforms = lib.platforms.linux;
  };
}

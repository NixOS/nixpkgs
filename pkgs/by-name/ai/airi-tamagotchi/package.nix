{
  lib,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
  autoPatchelfHook,
  breakpointHook,
  cargo-tauri,
  pkg-config,
  pnpm,
  wrapGAppsHook3,
  atk,
  cacert,
  darwin,
  glib,
  libayatana-appindicator,
  nodejs,
  webkitgtk_4_1,
}:
rustPlatform.buildRustPackage (final: {
  pname = "airi-tamagotchi";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "moeru-ai";
    repo = "airi";
    rev = "v${final.version}";
    hash = "sha256-ntuPcMiECqeJwGkGKF3kWvmaeevahWKAQsxU9EUgM74=";
  };

  cargoLock.lockFile = final.src + "/Cargo.lock";

  pnpmDeps = pnpm.fetchDeps {
    inherit (final) pname version src;
    hash = "sha256-Eb1eV5hRFWXpL1iDBMssrG8GSC22iLAmMD2u3+uLWic=";
  };

  # Cache of assets downloaded during vite build
  assets = stdenvNoCC.mkDerivation {
    pname = "${final.pname}-assets";
    inherit (final) version src pnpmDeps;

    nativeBuildInputs = [
      cacert # For network request
      nodejs
      pnpm.configHook
    ];

    buildPhase = ''
      runHook preBuild

      pnpm run build:packages
      pnpm -F @proj-airi/stage-tamagotchi run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r apps/stage-tamagotchi/.cache/assets $out

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-1UAroTvzNckUNAOGTF0xd5T9iu381esJ29l8zgTMIzc=";
  };

  nativeBuildInputs =
    [
      autoPatchelfHook
      breakpointHook
      cargo-tauri.hook
      nodejs
      pkg-config
      pnpm.configHook
    ]
    ++ lib.optionals stdenvNoCC.isLinux [
      wrapGAppsHook3
    ];

  buildInputs =
    [
      atk
      glib
      libayatana-appindicator
    ]
    ++ lib.optionals stdenvNoCC.isLinux [
      webkitgtk_4_1
    ]
    ++ lib.optionals stdenvNoCC.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreGraphics
    ];

  configurePhase = ''
    runHook preConfigure

    mkdir apps/stage-tamagotchi/.cache
    cp -r $assets/assets apps/stage-tamagotchi/.cache

    runHook postConfigure
  '';

  preBuild = ''
    pnpm run build:packages
  '';

  buildAndTestSubdir = "apps/stage-tamagotchi";

  postInstall = ''
    mv $out/bin/app $out/bin/airi
  '';

  # Add missing runtime dependency
  preFixup = ''
    patchelf --add-needed libayatana-appindicator3.so.1 $out/bin/airi
  '';

  meta = {
    description = "Self-hostable AI waifu / companion / VTuber";
    longDescription = ''
      AIRI is a container of souls of AI waifu / virtual characters to bring them into our worlds,
      wishing to achieve Neuro-sama's altitude, completely LLM and AI driven, capable of realtime
      voice chat, Minecraft playing, Factorio playing. It can be run in Browser or Desktop.
    '';
    homepage = "https://github.com/moeru-ai/airi";
    changelog = "https://github.com/moeru-ai/airi/releases/tag/v${final.version}";
    # While airi itself is licensed under MIT, it uses the nonfree Cubism SDK. Whether it's
    # redistributable remains a question, so we say it's not.
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ weathercold ];
    mainProgram = "airi";
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,
  webkitgtk_4_1,
  glib-networking,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "betaflight-configurator";
  version = "2026.6.2";
  src = fetchFromGitHub {
    owner = "betaflight";
    repo = "betaflight-configurator";
    tag = "${finalAttrs.version}";
    hash = "sha256-vh95IiGBaMLtmn87f/fsvP5qM+DgU7CP1+19t3oi5rs=";
  };

  cargoHash = "sha256-UNrUFmGfnryO4RWnst64C0AQN2cR+ioTtybtl6azMcA=";
  cargoRoot = "src-tauri";

  buildAndTestSubdir = finalAttrs.cargoRoot;

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-M6k/wXnLgmt2HyfnDW0XcOY/zfngjaDRHoASGkngfX0=";
    fetcherVersion = 2;
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    glib-networking
    udev
  ];

  postPatch = ''
    # Replace commitHash used by the app
    substituteInPlace vite.config.js \
      --replace-fail 'child.execSync("git rev-parse --short HEAD").toString().trim()' '"${finalAttrs.src.rev}"'
  '';

  checkPhase = ''
    runHook preCheck
    npx vitest run
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross platform configuration and management application for the Betaflight firmware";
    mainProgram = "betaflight-app";
    longDescription = ''
      A crossplatform configuration and management application for the Betaflight flight control system.

      Various types of aircraft are supported by the tool and by Betaflight, e.g. quadcopters, hexacopters, octocopters and fixed-wing aircraft.
    '';
    homepage = "https://github.com/betaflight/betaflight-configurator";
    changelog = "https://betaflight.com/docs/category/release-notes";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      wucke13
      issai
    ];
    platforms = lib.platforms.linux;
  };
})

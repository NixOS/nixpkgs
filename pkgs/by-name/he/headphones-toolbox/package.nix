{
  cargo-tauri,
  darwin,
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nix-update-script,
  nodejs,
  pkg-config,
  rustPlatform,
  stdenv,
  webkitgtk_4_1,
  wrapGAppsHook3,
  yarnConfigHook,
}:

rustPlatform.buildRustPackage (rec {
  pname = "headphones-toolbox";
  version = "0.0.7";
  tag = "test-tauri-v2-2";

  src = fetchFromGitHub {
    owner = "george-norton";
    repo = pname;
    rev = "${tag}";
    hash = "sha256-X2HTEPxvBzbhfN1vqQVk81Qk1Z+EV+7/SpjZrDHv+fM=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-Ln5U0KKsKm6ZLViZIWfBiBjm/mQNEIxaj4nTR55PcRg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VgCxYYNBV45sTzouS5NE7nOUViPj0gJO7DSKlJSAT4U=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  nativeBuildInputs =
    [
      cargo-tauri.hook
      nodejs
      pkg-config
      wrapGAppsHook3
      yarnConfigHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.DarwinTools # sw_vers
    ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ webkitgtk_4_1 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.WebKit ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    ln -s $out/Applications/Ploopy\ Headphones\ Toolbox.app/Contents/MacOS/${meta.mainProgram} $out/bin/${meta.mainProgram}
    makeWrapper $out/{Applications/Ploopy\ Headphones\ Toolbox.app/Contents/MacOS,bin}/${meta.mainProgram}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "UI for configuring Ploopy Headphones";
    homepage = "https://github.com/ploopyco/${meta.mainProgram}/";
    license = lib.licenses.gpl3Only;
    mainProgram = "headphones-toolbox";

    maintainers = with lib.maintainers; [
      flacks
      knarkzel
      nyabinary
    ];

    platforms = lib.platforms.unix;
  };
})

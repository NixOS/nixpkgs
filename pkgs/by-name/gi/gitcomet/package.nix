{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  desktop-file-utils,
  fontconfig,
  freetype,
  zlib,
  libxcb,
  libxkbcommon,
  libGL,
  vulkan-loader,
  wayland,
  git,
  xdg-utils,
  makeBinaryWrapper,
  writableTmpDirAsHomeHook,
  testers,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitcomet";
  version = "0.2.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Auto-Explore";
    repo = "GitComet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V8OFHimks8QzV1sSz0DKR5j1HzMFF3mm81SueH87S9E=";
  };

  cargoHash = "sha256-RwrSuN8xaE/QyX5IUbdWc5q7qWnm5MSbbSoq1iKTobY=";

  # Disable upstream's rustflags overrides to avoid linker and CPU target issues
  postPatch = ''
    rm .cargo/config.toml
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # gpui_ce_apple generates Metal shader bindings from its sibling gpui
    # directory, but cargo vendoring stores that crate as gpui-ce-<version>.
    for apple in "$cargoDepsCopy"/source-git-*/gpui_ce_apple-[0-9]*; do
      apple_parent=$(dirname "$apple")
      ln -s "$apple_parent"/gpui-ce-[0-9]* "$apple_parent/gpui"
    done
  '';

  nativeBuildInputs = [
    pkg-config
    desktop-file-utils
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Required by gpui_ce_media, which generates CoreMedia bindings with bindgen
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    freetype
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxcb
    libxkbcommon
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "ui-gpui"
    "gix"
  ];

  cargoBuildFlags = [
    "--package=gitcomet"
    "--bin=gitcomet"
  ];

  checkNoDefaultFeatures = true;
  checkFeatures = [ "gix" ];
  cargoTestFlags = [
    "--workspace"
    "--exclude=gitcomet-ui-gpui"
  ];

  nativeCheckInputs = [
    git
    writableTmpDirAsHomeHook
  ];

  env.GIT_PAGER = "cat";
  dontUseCargoParallelTests = true;

  postInstall = ''
    install -Dm644 assets/linux/gitcomet.desktop \
      $out/share/applications/gitcomet.desktop
    desktop-file-validate $out/share/applications/gitcomet.desktop

    for size in 32 48 128 256 512; do
      install -Dm644 "assets/linux/hicolor/''${size}x''${size}/apps/gitcomet.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/gitcomet.png"
    done
  '';

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf $out/bin/gitcomet --add-rpath ${
        lib.makeLibraryPath [
          libGL
          vulkan-loader
          wayland
        ]
      }

    ''
    + ''
      wrapProgram $out/bin/gitcomet \
        --prefix PATH : "${
          lib.makeBinPath ([ git ] ++ lib.optionals stdenv.hostPlatform.isLinux [ xdg-utils ])
        }" \
        --set-default GITCOMET_NO_UPDATE_CHECK 1
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=^v([0-9]+[.][0-9]+[.][0-9]+)$"
        "--use-github-releases"
      ];
    };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Fast, resource-efficient Git GUI written in Rust";
    longDescription = ''
      GitComet is a Git graphical client built with Rust and the gpui
      toolkit, using gix as its Git implementation.
    '';
    homepage = "https://gitcomet.dev";
    changelog = "https://github.com/Auto-Explore/GitComet/releases/tag/v${finalAttrs.version}";
    # ofl covers the bundled font assets.
    license = with lib.licenses; [
      agpl3Only
      ofl
    ];
    maintainers = with lib.maintainers; [
      rachalaraj
      havunen
    ];
    mainProgram = "gitcomet";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

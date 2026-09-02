{
  lib,
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
  version = "0.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Auto-Explore";
    repo = "GitComet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VRd3HHYuHfOebAT3yC5Tv4CJdFUJkZJHQ8vTzY78OQ0=";
  };

  cargoHash = "sha256-L/UXaXC1zymbNfv7SGmOYSvUy/767mAWqL+3jwJwWcE=";

  # Disable upstream's rustflags overrides to avoid linker and CPU target issues
  postPatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    pkg-config
    desktop-file-utils
    makeBinaryWrapper
  ];

  buildInputs = [
    fontconfig
    freetype
    zlib
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

  postFixup = ''
    patchelf $out/bin/gitcomet --add-rpath ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
      ]
    }

    wrapProgram $out/bin/gitcomet \
      --prefix PATH : "${
        lib.makeBinPath [
          git
          xdg-utils
        ]
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
    platforms = lib.platforms.linux;
  };
})

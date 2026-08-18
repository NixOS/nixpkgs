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
  makeWrapper,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "gitcomet";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Auto-Explore";
    repo = "GitComet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kwb/XtqP6/4P7wcn4s+4fzpwZflGfReQ+QdKfBjf4hw=";
  };

  cargoHash = "sha256-XIpliBQh5RU3KiJxA6gbtrpfEsi9Iqt+x2OAINWNwNg=";

  # Avoid changing cargoHash merely because the GitComet version changes.
  cargoDepsName = finalAttrs.pname;

  # Upstream pins `-Ctarget-cpu=x86-64-v3` for x86_64, which emits AVX2/BMI2
  # instructions that fault on the baseline hardware Nixpkgs targets. Cargo
  # merges this file with the vendor config the setup hook writes one directory
  # up, so removing it here only drops upstream's flags. The rest of the file
  # only configures the Windows MSVC linker.
  postPatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    pkg-config
    desktop-file-utils
    makeWrapper
  ];

  buildInputs = [
    fontconfig
    # font-kit links freetype-sys and yeslogic-fontconfig-sys unconditionally on
    # Linux; libz-sys otherwise rebuilds a vendored zlib.
    freetype
    zlib
    # gpui links libxkbcommon and libxkbcommon-x11 (the latter needs libxcb).
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

  # Upstream's headless test configuration, from
  # .github/workflows/cross-platform-tests.yml:
  #   cargo test --workspace --exclude gitcomet-ui-gpui \
  #     --no-default-features --features gix --locked
  # The GUI crate's suite is only exercised upstream under a real X11/Wayland
  # session, so it is excluded here rather than run blind in the sandbox.
  checkNoDefaultFeatures = true;
  checkFeatures = [ "gix" ];
  cargoTestFlags = [
    "--workspace"
    "--exclude=gitcomet-ui-gpui"
  ];

  # The test suite drives the real git CLI and needs a writable HOME.
  nativeCheckInputs = [
    git
    writableTmpDirAsHomeHook
  ];

  # Some test commands inherit the build's pseudo-terminal. Avoid Git trying
  # to launch its default pager, which isn't available in the sandbox.
  GIT_PAGER = "cat";

  # Parts of the suite share process-global state between sibling tests and fail
  # in bursts when run concurrently.
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

  # GPUI dlopens Vulkan, EGL/GL and libwayland-client, so they have to be in the
  # RUNPATH. patchelf must run before wrapProgram replaces the ELF with a shell
  # wrapper.
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

  passthru.updateScript = nix-update-script {
    # Track stable vX.Y.Z releases, but ignore prereleases such as -rc.1.
    extraArgs = [
      "--version-regex=^v([0-9]+[.][0-9]+[.][0-9]+)$"
    ];
  };

  meta = {
    description = "Fast, resource-efficient Git GUI written in Rust";
    homepage = "https://gitcomet.dev";
    changelog = "https://github.com/Auto-Explore/GitComet/releases/tag/v${finalAttrs.version}";
    # AGPL-3.0-only for GitComet itself; the binary embeds the Fira Code, IBM
    # Plex Sans and Lilex fonts, which are OFL.
    license = with lib.licenses; [
      agpl3Only
      ofl
    ];
    maintainers = with lib.maintainers; [ havunen ];
    mainProgram = "gitcomet";
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  fontconfig,
  freetype,
  libxkbcommon,
  vulkan-loader,
  libGL,
  stdenv,
  wayland,
  libx11,
  libxcb,
  git,
  jujutsu,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jayjay";
  version = "0.3.20";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hewigovens";
    repo = "jayjay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-22Ny/EvghZN5oGu5rWR2BMU2HqpOj6waYV5RVXNxFqU=";
  };

  cargoHash = "sha256-QMRd+734s/JNSojHBC0QXE1+3MZ3ktQjQ8zecdSB42M=";

  # Skip jayjay-uniffi, which only provides bindings for the macOS SwiftUI app
  cargoBuildFlags = [
    "-p"
    "jayjay-cli"
    "-p"
    "jayjay-gpui"
  ];

  postPatch = ''
    substituteInPlace crates/jayjay-core/src/repo/command_process/tests.rs \
      --replace-fail '"/usr/bin/true"' '"true"'
  '';

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    freetype
    libxkbcommon
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libx11
    libxcb
  ];

  nativeCheckInputs = [
    git
    jujutsu
  ];

  checkFlags = [
    # jj 0.46 allows `jj git init` inside a Git worktree (warning only)
    "--skip=repo::init::tests::preserves_git_worktree_init_error"
    # jj 0.46 backs colocated workspaces with Git worktrees, which can't be re-added at the same path
    "--skip=repo_workspace_switch::removing_a_workspace_drops_drafts_parked_in_other_windows"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 shell/gpui/linux/dev.hewig.JayJay.desktop -t $out/share/applications
    install -Dm644 shell/gpui/linux/dev.hewig.JayJay.metainfo.xml -t $out/share/metainfo
    install -Dm644 docs/icon.svg $out/share/icons/hicolor/scalable/apps/dev.hewig.JayJay.svg
  '';

  postFixup = ''
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf $out/bin/jayjay-gpui --add-rpath ${
        lib.makeLibraryPath [
          libGL
          vulkan-loader
          wayland
        ]
      }
    ''}
    for bin in $out/bin/*; do
      wrapProgram $bin --suffix PATH : ${
        lib.makeBinPath [
          git
          jujutsu
        ]
      }
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI and CLI for the Jujutsu version control system";
    homepage = "https://github.com/hewigovens/jayjay";
    changelog = "https://github.com/hewigovens/jayjay/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20 # crates/
      bsl11 # shell/ (GUI)
    ];
    maintainers = with lib.maintainers; [ rpqt ];
    platforms = lib.platforms.linux;
    mainProgram = "jayjay";
  };
})

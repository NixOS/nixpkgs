{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  pkg-config,
  fontconfig,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  libxcb,
  libxkbcommon,
  wayland,
  libGL,
  openssl,
  oniguruma,
  vulkan-loader,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inlyne";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "Inlyne-Project";
    repo = "inlyne";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bUM9Mn/C9l6s6ucoLRo25m4PbbW3gp5d3AvO/9GTJcI=";
  };

  cargoHash = "sha256-IaaojW5PYSUwyh1iv2HrDidIV8keEykKHY61rpcCAPc=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    fontconfig
    libxcursor
    libxi
    libxrandr
    libxcb
    wayland
    libxkbcommon
    openssl
  ];

  # use system oniguruma since the bundled one fails to build with gcc15
  env.RUSTONIG_SYSTEM_LIBONIG = 1;

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # time out on darwin
    "--skip=interpreter::tests::centered_image_with_size_align_and_link"
    "--skip=watcher::tests::the_gauntlet"
  ];

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd inlyne \
        --bash completions/inlyne.bash \
        --fish completions/inlyne.fish \
        --zsh completions/_inlyne
    ''
    + ''
      install -Dm444 assets/inlyne.desktop -t $out/share/applications
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/inlyne \
      --add-needed ${lib.getLib vulkan-loader}/lib/libvulkan.so \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          libx11
          libxkbcommon
        ]
      }
  '';

  meta = {
    description = "GPU powered browserless markdown viewer";
    homepage = "https://github.com/Inlyne-Project/inlyne";
    changelog = "https://github.com/Inlyne-Project/inlyne/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "inlyne";
  };
})

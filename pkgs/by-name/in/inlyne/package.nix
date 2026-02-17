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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inlyne";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Inlyne-Project";
    repo = "inlyne";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ueE1NKbCMBUBrrdsHkwZ5Yv6LD3tQL3ZAk2O4xoYOcw=";
  };

  cargoHash = "sha256-jSUqpryUgOL0qo0gbbH4s24krrPsLOSNc6FQUEUeeUQ=";

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
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          libx11
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

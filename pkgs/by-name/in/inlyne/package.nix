{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  pkg-config,
  fontconfig,
  xorg,
  libxkbcommon,
  wayland,
  libGL,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "inlyne";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Inlyne-Project";
    repo = "inlyne";
    rev = "v${version}";
    hash = "sha256-ueE1NKbCMBUBrrdsHkwZ5Yv6LD3tQL3ZAk2O4xoYOcw=";
  };

  cargoHash = "sha256-jSUqpryUgOL0qo0gbbH4s24krrPsLOSNc6FQUEUeeUQ=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    fontconfig
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libxcb
    wayland
    libxkbcommon
    openssl
  ];

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
          xorg.libX11
        ]
      }
  '';

  meta = with lib; {
    description = "GPU powered browserless markdown viewer";
    homepage = "https://github.com/Inlyne-Project/inlyne";
    changelog = "https://github.com/Inlyne-Project/inlyne/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "inlyne";
  };
}

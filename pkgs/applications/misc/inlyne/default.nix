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
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "inlyne";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Inlyne-Project";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ueE1NKbCMBUBrrdsHkwZ5Yv6LD3tQL3ZAk2O4xoYOcw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-jSUqpryUgOL0qo0gbbH4s24krrPsLOSNc6FQUEUeeUQ=";

  nativeBuildInputs =
    [
      installShellFiles
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pkg-config
    ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      fontconfig
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
      xorg.libxcb
      wayland
      libxkbcommon
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk_11_0.frameworks.AppKit
    ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # time out on darwin
    "--skip=interpreter::tests::centered_image_with_size_align_and_link"
    "--skip=watcher::tests::the_gauntlet"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd inlyne \
      --bash completions/inlyne.bash \
      --fish completions/inlyne.fish \
      --zsh completions/_inlyne
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
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "inlyne";
  };
}

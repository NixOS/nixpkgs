{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  fontconfig,
  libxkbcommon,
  openssl,
  pkg-config,
  xorg,
  vulkan-loader,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "furtherance";
  version = "26.1.0";

  src = fetchFromGitHub {
    owner = "unobserved-io";
    repo = "Furtherance";
    rev = finalAttrs.version;
    hash = "sha256-EwOLTq82NNuRMUCFSKryl6fBtXxhNps+tzOo3Uhe3yA=";
  };

  cargoHash = "sha256-iJW7tnGnwdp494ylJyNEuC80SIV8wRu8ygd5lcul2KA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fontconfig
    openssl
    libxkbcommon
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcursor
    xorg.libXi
    vulkan-loader
    wayland
  ];

  checkFlags = [
    # panicked at src/tests/timer_tests.rs:30:9
    "--skip=tests::timer_tests::timer_tests::test_split_task_input_basic"
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/${finalAttrs.pname} \
      --add-rpath ${
        lib.makeLibraryPath [
          vulkan-loader
          libxkbcommon
          wayland
        ]
      }
  '';

  meta = {
    description = "Track your time without being tracked";
    mainProgram = "furtherance";
    homepage = "https://github.com/unobserved-io/Furtherance";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      CaptainJawZ
      locnide
    ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  fontconfig,
  libxkbcommon,
  openssl,
  pkg-config,
  libxscrnsaver,
  libxi,
  libxcursor,
  libx11,
  vulkan-loader,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "furtherance";
  version = "26.1.1";

  src = fetchFromGitHub {
    owner = "unobserved-io";
    repo = "Furtherance";
    rev = finalAttrs.version;
    hash = "sha256-VG1Ghhi74tkPU9bgauV98Gp5kVoZJ1cJUqWLWnrUAOU=";
  };

  cargoHash = "sha256-6S0L8FHI5eCTzhxlew35pK7TewMplKKJDaqJdtoYRnM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fontconfig
    openssl
    libxkbcommon
    libx11
    libxscrnsaver
    libxcursor
    libxi
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

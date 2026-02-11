{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  makeWrapper,
  pkg-config,
  autoPatchelfHook,

  # buildInputs
  fontconfig,
  libgcc,
  libxkbcommon,
  libxi,
  libxcursor,
  libx11,

  libGL,
  wayland,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "crusader";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Zoxc";
    repo = "crusader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M5zMOOYDS91p0EuDSlQ3K6eiVQpbX6953q+cXBMix2s=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  cargoHash = "sha256-f0TWiRX203/gNsa9UEr/1Bv+kUxLAK/Zlw+S693xZlE=";

  # autoPatchelfHook required on linux for crusader-gui
  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    fontconfig
    libgcc
    libxkbcommon
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxcursor
    libxi
  ];

  # required for crusader-gui
  runtimeDependencies = [
    libGL
    libxkbcommon
  ];

  postFixup = ''
    # the program looks for libwayland-client.so at runtime
    wrapProgram $out/bin/crusader-gui \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ wayland ]}
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Network throughput and latency tester";
    homepage = "https://github.com/Zoxc/crusader";
    changelog = "https://github.com/Zoxc/crusader/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ x123 ];
    platforms = lib.platforms.all;
    mainProgram = "crusader";
  };
})

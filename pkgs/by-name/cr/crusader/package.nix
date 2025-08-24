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
  xorg,

  libGL,
  wayland,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "crusader";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Zoxc";
    repo = "crusader";
    tag = "v${version}";
    hash = "sha256-M5zMOOYDS91p0EuDSlQ3K6eiVQpbX6953q+cXBMix2s=";
  };

  sourceRoot = "${src.name}/src";

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
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
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
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Network throughput and latency tester";
    homepage = "https://github.com/Zoxc/crusader";
    changelog = "https://github.com/Zoxc/crusader/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    platforms = lib.platforms.all;
    mainProgram = "crusader";
  };
}

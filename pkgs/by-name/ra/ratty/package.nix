{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  versionCheckHook,
  alsa-lib,
  fontconfig,
  udev,
  vulkan-loader,
  wayland,
  libxkbcommon,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ratty";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "ratty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fDNlyTOhwI1nzNf2/Z9DWtTEdJCZEDogLu13ETbpJAw=";
  };

  cargoHash = "sha256-4oLBONIyC924UGTw0d9RzGvNBolWdLMzzC+mihcD3B0=";

  nativeBuildInputs = [ pkg-config ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  # needed by bevy, see: https://github.com/bevyengine/bevy/blob/latest/docs/linux_dependencies.md
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    fontconfig
    udev
    vulkan-loader
    wayland
    libxkbcommon
    libx11
    libxcursor
    libxi
    libxrandr
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = toString [
      "-framework AppKit"
      "-framework CoreAudio"
      "-framework CoreFoundation"
      "-framework CoreGraphics"
      "-framework Foundation"
      "-framework IOKit"
      "-framework Metal"
      "-framework QuartzCore"
    ];
  };

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/ratty \
      --add-rpath ${
        lib.makeLibraryPath [
          alsa-lib
          udev
          vulkan-loader
          libxkbcommon
          libx11
          libxcursor
          libxi
          libxrandr
        ]
      }
  '';

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  meta = {
    description = "GPU-rendered terminal emulator with inline 3D graphics";
    homepage = "https://github.com/orhun/ratty";
    changelog = "https://github.com/orhun/ratty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akosseres ];
    mainProgram = "ratty";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

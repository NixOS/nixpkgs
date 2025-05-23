{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  zstd,
  stdenv,
  alsa-lib,
  libxkbcommon,
  udev,
  vulkan-loader,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jumpy";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "fishfolk";
    repo = "jumpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g/CpSycTCM1i6O7Mir+3huabvr4EXghDApquEUNny8c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-y0VdzC2URitYzU+DLtAd0mppjF3dhznXqvjxHmOBBKs=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs =
    [
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libxkbcommon
      udev
      vulkan-loader
      wayland
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      rustPlatform.bindgenHook
    ];

  cargoBuildFlags = [
    "--bin"
    "jumpy"
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # jumpy only loads assets from the current directory
  # https://github.com/fishfolk/bones/blob/f84d07c2f2847d9acd5c07098fe1575abc496400/framework_crates/bones_asset/src/io.rs#L50
  postInstall = ''
    mkdir $out/share
    cp -r assets $out/share
    wrapProgram $out/bin/jumpy --chdir $out/share
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/.jumpy-wrapped \
      --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = {
    description = "Tactical 2D shooter played by up to 4 players online or on a shared screen";
    mainProgram = "jumpy";
    homepage = "https://fishfolk.org/games/jumpy";
    changelog = "https://github.com/fishfolk/jumpy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
  };
})

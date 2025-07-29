{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
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

  # This patch may be removed in the next release
  cargoPatches = [
    (fetchpatch2 {
      url = "https://github.com/fishfolk/jumpy/commit/8234e6d2c0b33c75e2112596ded1734fdba50fb8.patch?full_index=1";
      hash = "sha256-IWjBw1Wj/6CT/x6xm6vfpUMfk7A5/EsdbPDvWywRFc8=";
    })
  ];

  cargoHash = "sha256-2I9s1zH94GRqXGBxZYyXOQwNeYrpV1UhUSKGCs9Ce9Q=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
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
    license = with lib.licenses; [
      mit # or
      asl20
      # Assets
      cc-by-nc-40
    ];
    maintainers = with lib.maintainers; [ figsoda ];
  };
})

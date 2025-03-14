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
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "jumpy";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "fishfolk";
    repo = "jumpy";
    rev = "v${version}";
    sha256 = "sha256-ggePJH2kKJ17aOWRKUnLyolIdSzlc6Axf5Iw74iFfek=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hVEpTNTXwOQoxlhOewUvHyfBh+APnx8Fox90CmdMRQ4=";

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
      darwin.apple_sdk_11_0.frameworks.Cocoa
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

  meta = with lib; {
    description = "Tactical 2D shooter played by up to 4 players online or on a shared screen";
    mainProgram = "jumpy";
    homepage = "https://fishfight.org/";
    changelog = "https://github.com/fishfolk/jumpy/releases/tag/v${version}";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}

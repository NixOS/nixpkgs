{
  autoPatchelfHook,
  darwin,
  fetchFromGitHub,
  git,
  lib,
  libglvnd,
  libxkbcommon,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  vulkan-loader,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "gupax";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "hinto-janai";
    repo = "gupax";
    rev = "v${version}";
    hash = "sha256-duDqlCUAMYXM+M3Ifzwshlkr80PcqqXE/G4zih/uwA0=";
    leaveDotGit = true; # git command in build.rs
  };

  cargoHash = "sha256-a9Q0/AA/kJCcZl3maROuwUH9/tBGDZdxqBYSEIXr6EA=";

  cargoBuildFlags = [
    # disables updates but also uses /usr/bin paths
    # p2pool and xmrig will need to be symlinked anyways
    "--features distro"
  ];

  checkFlags = [
    # requires filesystem write
    "--skip disk::test::create_and_serde_gupax_p2pool_api"
  ];

  nativeBuildInputs =
    [
      git
      pkg-config
    ]
    ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs =
    [
      openssl
      stdenv.cc.cc.libgcc or null # libgcc_s.so
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk_11_0.frameworks;
      [
        AppKit
        ApplicationServices
        Carbon
        CoreData
        CoreFoundation
        CoreGraphics
        CoreServices
        CoreVideo
        Foundation
        IOKit
        Metal
        OpenGL
        QuartzCore
        Security
      ]
    );

  runtimeDependencies = lib.optionals stdenv.isLinux [
    libglvnd # libEGL.so
    libxkbcommon
    vulkan-loader # libvulkan.so
    wayland # libwayland-client.so
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "GUI Uniting P2Pool And XMRig";
    homepage = "https://gupax.io";
    changelog = "https://github.com/hinto-janai/gupax/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ RoGreat ];
    mainProgram = "gupax";
    platforms = platforms.all;
  };
}

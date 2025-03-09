{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,

  bzip2,
  sdl3,
  zstd,

  moltenvk,

  libxkbcommon,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "gopher64";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "gopher64";
    repo = "gopher64";
    tag = "v${version}";
    hash = "sha256-mDjqVQD4Vms1fSCGgCAWKL5LKRY36tH7Vq4NSnIVDCs=";
    fetchSubmodules = true;
  };

  cargoPatches = [
    # upstream rebuilds SDL3 from source
    # this patch makes it use the SDL3 library provided by nixpkgs
    ./use-sdl3-via-pkg-config.patch

    ./dont-set-march.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-PSXzeyUkCnczEjKA98xpWSXuLp+MULyCi85CZYuitqg=";

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      bzip2
      sdl3
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      moltenvk
    ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/gopher64 --add-rpath ${
      lib.makeLibraryPath [
        libxkbcommon
        vulkan-loader
        wayland
      ]
    }
  '';

  meta = {
    changelog = "https://github.com/gopher64/gopher64/releases/tag/${src.tag}";
    description = "N64 emulator written in Rust";
    homepage = "https://github.com/gopher64/gopher64";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "gopher64";
  };
}

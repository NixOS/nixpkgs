{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  fontconfig,
  openssl,
  sdl3,
  sdl3-ttf,
  vulkan-loader,
  zstd,

  # nativeInstallCheckInputs
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gopher64";
  version = "1.1.34";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gopher64";
    repo = "gopher64";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-RbP+dBJezQanqsUoM3shyCFK1JUt5uOGEp+/H5IXL4c=";
  };

  cargoPatches = [
    # upstream rebuilds SDL3 from source
    # this patch makes it use the SDL3 library provided by nixpkgs
    ./use-sdl3-via-pkg-config.patch

    ./no-lto.patch
    ./no-git-describe.patch
  ];

  cargoHash = "sha256-iAuWK0E9gy1cpxFeY0l7VCOHCRQwpE4/WL31Ma+6n78=";

  env = {
    OPENSSL_NO_VENDOR = 1;
    ZSTD_SYS_USE_PKG_CONFIG = 1;

    GIT_DESCRIBE = finalAttrs.version;
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    openssl
    sdl3
    sdl3-ttf
    zstd
  ];

  # no checks
  doCheck = false;

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/gopher64 --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "N64 emulator";
    homepage = "https://loganmc10.itch.io/gopher64";
    downloadPage = "https://github.com/gopher64/gopher64/releases";
    changelog = "https://github.com/gopher64/gopher64/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      prince213
      tomasajt
    ];
    mainProgram = "gopher64";
  };
})

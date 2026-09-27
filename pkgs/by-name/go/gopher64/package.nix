{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,

  # nativeBuildInputs
  cargo-bundle,
  cctools,
  pkg-config,

  # buildInputs
  fontconfig,
  moltenvk,
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
    # upstream builds SDL3 from source or uses a prebuilt binary
    # this patch makes the package use the SDL3 dynamic library provided by nixpkgs
    ./use-sdl3-via-pkg-config.patch

    ./no-lto.patch
    ./no-git-describe.patch
    ./no-homebrew.patch
  ];

  cargoHash = "sha256-KONuRVpV2D6ciiI+x8ijy9B0NiDtMhPkNI4XF3OdjxU=";

  # don't use lld on aarch64-linux
  postPatch = ''
    substituteInPlace .cargo/config.toml \
      --replace-fail 'rustflags = ["-C", "link-arg=-fuse-ld=lld"]' ""
  '';

  env = {
    OPENSSL_NO_VENDOR = "1";
    ZSTD_SYS_USE_PKG_CONFIG = true;
    GIT_DESCRIBE = finalAttrs.version;
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cargo-bundle
    cctools.libtool
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

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    # cargo-bundle expects the binary in target/release
    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
    mv $release_target/gopher64 target/release/gopher64

    export CARGO_BUNDLE_SKIP_BUILD=true
    app_path=$(cargo bundle --release | xargs)

    mkdir -p $out/Applications $out/bin
    mv $app_path $out/Applications/

    ln -s $out/Applications/Gopher64.app/Contents/MacOS/gopher64 $out/bin/gopher64

    runHook postInstall
  '';

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf "$out/bin/gopher64" \
        --add-rpath "${lib.makeLibraryPath [ vulkan-loader ]}"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool $out/Applications/Gopher64.app/Contents/MacOS/gopher64 \
        -add_rpath "${lib.makeLibraryPath [ moltenvk ]}"
    '';

  # Error: Os { code: 1, kind: PermissionDenied, message: "Operation not permitted" }
  doInstallCheck = !stdenv.hostPlatform.isDarwin;
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

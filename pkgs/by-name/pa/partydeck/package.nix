{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  pkg-config,

  bubblewrap,
  fontconfig,
  fuse-overlayfs,
  gamescope-kbm,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  openssl,
  umu-launcher,
  util-linux,
  wayland,
  xdg-utils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "partydeck";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "partydeck";
    repo = "partydeck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BLgaQxmnLaKWo/RFOCpdjwfoYnyHXxoJy1ImJU/8ceI=";
  };

  cargoHash = "sha256-pPbMKyp3e3umhVwZ7Aj3T9RUPPTdZlGYgWUjUdy2YB8=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    fontconfig
    libGL
    libx11
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    openssl
    wayland
  ];

  runtimePath = [
    bubblewrap
    fuse-overlayfs
    gamescope-kbm
    umu-launcher
    util-linux
    xdg-utils
  ];

  prePatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.8.5"' 'version = "${finalAttrs.version}"'
  '';

  postPatch = ''
    substituteInPlace src/paths.rs \
      --replace-fail 'PathBuf::from("/usr/share/partydeck")' \
                     'PathBuf::from("${placeholder "out"}/share/partydeck")'
  '';

  postInstall = ''
    install -Dm644 res/*.js -t $out/share/partydeck
    install -Dm644 res/*.png -t $out/share/partydeck
    install -Dm755 res/GamingModeLauncher.sh -t $out/share/partydeck
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/partydeck \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}:/run/opengl-driver/lib" \
      --prefix PATH : "${lib.makeBinPath finalAttrs.runtimePath}"
  '';

  meta = {
    description = "Split-screen game launcher for Linux and SteamOS";
    homepage = "https://github.com/partydeck/partydeck";
    changelog = "https://github.com/partydeck/partydeck/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "partydeck";
    maintainers = [ lib.maintainers.imalison ];
    platforms = lib.platforms.linux;
  };
})

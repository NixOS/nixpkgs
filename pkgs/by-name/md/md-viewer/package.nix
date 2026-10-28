{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  expat,
  fontconfig,
  freetype,
  libGL,
  libxkbcommon,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libgcc,
  autoPatchelfHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "md-viewer";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "aydiler";
    repo = "md-viewer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4yudGSpMm3QsI3wnMGV6HOWVYzny76UGUPQEwxZyILo=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-dZCtry5AJ3lHfOtvj9UBtnclrKYoScs+Grm6fBQ/Wa4=";
  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = [
    expat
    fontconfig
    freetype
    libGL
    libxkbcommon
    wayland
    libx11
    libxcursor
    libxi
    libxrandr
    libgcc
  ];

  # wayland-sys / x11-dl / glutin dlopen these at runtime, so they never
  # appear in DT_NEEDED and autoPatchelfHook needs an explicit hint.
  runtimeDependencies = finalAttrs.buildInputs;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/aydiler/md-viewer/releases/tag/v${finalAttrs.version}";
    description = "Fast, lightweight markdown viewer for Linux with tabs, file explorer, and live reload";
    homepage = "https://github.com/aydiler/md-viewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ m1m3-50 ];
    mainProgram = "md-viewer";
    platforms = lib.platforms.linux;
  };
})

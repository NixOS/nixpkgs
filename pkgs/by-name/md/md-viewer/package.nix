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
  makeWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "md-viewer";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "aydiler";
    repo = "md-viewer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1c4Q/45PIuWwSXixFFM7TCvMN/j8FvHirHogRCaRdbM=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-GzXsM/SJWXgI2M2Osj9GK0V7mhhSB2CJ7mIdXrFvkpM=";
  nativeBuildInputs = [
    pkg-config
    makeWrapper
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
  ];

  postFixup = ''
    wrapProgram $out/bin/md-viewer \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}
  '';

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

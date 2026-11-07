{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  freetype,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mmterm";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "roramirez";
    repo = "mmterm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EKrEKaIA9uAarPJECdR9aqWDBJ2c2l/K+vEZuIVT89o=";
  };

  cargoHash = "sha256-tkQLxgVjcCX/NfJdyb1XLkzHbNgc3km0YxqiWiB0jkQ=";

  doCheck = false;

  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    freetype
    libGL
    libx11
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    wayland
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform terminal emulator with modal input (vim-style), PTY backend, and split-pane support";
    homepage = "https://github.com/roramirez/mmterm";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ a-maccormack ];
    mainProgram = "mmterm";
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cairo,
  pam,
  gdk-pixbuf,
  librsvg,
  pango,
  libxkbcommon,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustlock";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "JorySeverijnse";
    repo = "rustlock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mfQcMCUDncEZ/4qzMna//uzhtrow4axnuTnF88wnvi0=";
  };

  cargoHash = "sha256-AXWEf4xRARcuOn/rEMhNfNNC6HY/1BZtQSZetX15Eqs=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    cairo
    pam
    gdk-pixbuf
    librsvg
    pango
    libxkbcommon
    dbus
  ];

  meta = {
    description = "A high-performance Wayland screen locker written in Rust";
    homepage = "https://github.com/JorySeverijnse/rustlock";
    license = licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ JorySeverijnse ];
    mainProgram = "rustlock";
  };
})

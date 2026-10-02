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
  version = "1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JorySeverijnse";
    repo = "rustlock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5dsUEErvabk4mx/ABgnKjx7tWQ7Q+f8iXCSt5xf2zOI=";
  };

  cargoHash = "sha256-x9sYSCiGV7FkJiI3TEq20PTsxTnKZhTAq2l/c8486q4=";

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
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jory ];
    mainProgram = "rustlock";
  };
})

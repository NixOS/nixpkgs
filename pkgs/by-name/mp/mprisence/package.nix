{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mprisence";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "lazykern";
    repo = "mprisence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tzxuofwhYq6iRZ+f+T9KkXCV9gIplYc1LdB85D75hBA=";
  };

  cargoHash = "sha256-W4/ppT37h+Ho7oVKA/2KhCjQeZX0NiIqdopQmBWf/Xc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    openssl
  ];

  meta = {
    description = "Highly customizable Discord Rich Presence for MPRIS media players on Linux";
    homepage = "https://github.com/lazykern/mprisence";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toasteruwu ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    mainProgram = "mprisence";
  };
})

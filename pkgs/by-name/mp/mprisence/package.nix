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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "lazykern";
    repo = "mprisence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ss6RXxtpSI3jfq5CAwRLE0XA3tFkIBI+JMyUov2DSpM=";
  };

  cargoHash = "sha256-AKj+DibLyoWUw+082m5wMVnZAY4Kmf3+daRJDGeLKtc=";

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

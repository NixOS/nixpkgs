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
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "lazykern";
    repo = "mprisence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qF0jG9tc3tp2ChGCGE3YUZoTaQoTmLLd39iBWeSS7wU=";
  };

  cargoHash = "sha256-32zBqZJoo0C+4ogEbEz4rxyATG9dbibp7NxMXYYJNsE=";

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

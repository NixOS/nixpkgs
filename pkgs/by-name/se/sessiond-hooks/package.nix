{
  lib,
  fetchFromTangled,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "sessiond-hooks";
  version = "0.2.0";

  src = fetchFromTangled {
    did = "did:plc:vj3bxta3i3cp26nn46yideoh";
    tag = "${finalAttrs.pname}-v${finalAttrs.version}";
    hash = "sha256-X2ePs10hjZNOcHAJuN4J5KeBQaW24E2jMRq0biNdY3E=";
  };

  cargoHash = "sha256-+ENVyHs4UFsN62rkIau1aXC2RmF3Mqtj6XWeR55rR8w=";

  cargoBuildFlags = [
    "--locked"
    "-p"
    "sessiond-hooks"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  meta = {
    description = "Launch and supervise per-user session hooks with sessiond";
    homepage = "https://tangled.org/r0chd.pl/sessiond";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.r0chd ];
    platforms = lib.platforms.linux;
    mainProgram = "sessiond-hooks";
  };
})

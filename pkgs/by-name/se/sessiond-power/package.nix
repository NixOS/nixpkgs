{
  lib,
  fetchFromTangled,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "sessiond-power";
  version = "0.1.0";

  src = fetchFromTangled {
    did = "did:plc:vj3bxta3i3cp26nn46yideoh";
    tag = "${finalAttrs.pname}-v${finalAttrs.version}";
    hash = "sha256-X2ePs10hjZNOcHAJuN4J5KeBQaW24E2jMRq0biNdY3E=";
  };

  cargoHash = "sha256-+ENVyHs4UFsN62rkIau1aXC2RmF3Mqtj6XWeR55rR8w=";

  cargoBuildFlags = [
    "--locked"
    "-p"
    "sessiond-power"
    "-p"
    "sessiond-rebootctl"
    "-p"
    "sessiond-poweroffctl"
    "-p"
    "sessiond-suspendctl"
    "-p"
    "sessiond-hibernatectl"
    "-p"
    "sessiond-hybrid-sleepctl"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  meta = {
    description = "Power management service";
    homepage = "https://tangled.org/r0chd.pl/sessiond";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.r0chd ];
    platforms = lib.platforms.linux;
    mainProgram = "sessiond-power";
  };
})

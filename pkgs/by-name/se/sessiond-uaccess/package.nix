{
  lib,
  fetchFromTangled,
  rustPlatform,
  pkg-config,
  udev,
  acl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "sessiond-uaccess";
  version = "0.1.1";

  src = fetchFromTangled {
    did = "did:plc:vj3bxta3i3cp26nn46yideoh";
    tag = "${finalAttrs.pname}-v${finalAttrs.version}";
    hash = "sha256-X2ePs10hjZNOcHAJuN4J5KeBQaW24E2jMRq0biNdY3E=";
  };

  cargoHash = "sha256-+ENVyHs4UFsN62rkIau1aXC2RmF3Mqtj6XWeR55rR8w=";

  cargoBuildFlags = [
    "--locked"
    "-p"
    "sessiond-uaccess"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    acl
    udev
  ];

  postInstall = ''
    install -Dm644 -t $out/share/sessiond-uaccess/rules sessiond-uaccess/rules/*.lua
  '';

  meta = {
    description = "Dynamic device access manager";
    homepage = "https://tangled.org/r0chd.pl/sessiond";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.r0chd ];
    platforms = lib.platforms.linux;
    mainProgram = "sessiond-uaccess";
  };
})

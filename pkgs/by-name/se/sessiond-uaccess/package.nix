{
  lib,
  acl,
  udev,
  fetchgit,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "sessiond-uaccess";
  version = "0.1.0";

  cargoHash = "sha256-fdsMnG8a6+6ZCeE16vRkpX4BtJsbngvw4QTB3CNnMIM=";

  src = fetchgit {
    url = "https://tangled.org/did:plc:dkc53ch7wt7gilra4irpdqol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZOXS4ZUrIKLmnXpqZ9trmR0of8daqbRSkHFKdEl+Rwg=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    acl
    udev
  ];

  postInstall = ''
    install -d $out/share/sessiond-uaccess
    cp -r ${finalAttrs.src}/rules $out/share/sessiond-uaccess/
  '';

  meta = {
    description = "Dynamic device access manager";
    homepage = "https://tangled.org/r0chd.pl/sessiond-uaccess";
    license = lib.licenses.gpl3Only;
    maintainers = builtins.attrValues { inherit (lib.maintainers) r0chd; };
    platforms = lib.platforms.linux;
    mainProgram = "sessiond-uaccess";
  };
})

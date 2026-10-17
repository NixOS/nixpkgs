{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sg3_utils";
  version = "1.49";

  src = fetchurl {
    url = "https://sg.danny.cz/sg/p/sg3_utils-${finalAttrs.version}.tgz";
    sha256 = "sha256-hLpQlRCN2Xz7VU17OHIfKqK0P8H5PPgqvW7+TJ2iIKc=";
  };

  postPatch = ''
    substituteInPlace scripts/rescan-scsi-bus.sh \
      --replace-fail '/usr/bin/sg_' "$out/bin/sg_"
  '';

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [
    "out"
    "man"
    "dev"
    "lib"
  ];

  meta = {
    homepage = "https://sg.danny.cz/sg/";
    changelog = "https://sg.danny.cz/sg/p/sg3_utils.ChangeLog";
    description = "Utilities that send SCSI commands to devices";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      bsd2
      gpl2Plus
    ];
  };
})

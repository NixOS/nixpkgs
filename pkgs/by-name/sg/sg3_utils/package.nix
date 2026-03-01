{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sg3_utils";
  version = "1.48";

  src = fetchurl {
    url = "https://sg.danny.cz/sg/p/sg3_utils-${finalAttrs.version}.tgz";
    sha256 = "sha256-1itsPPIDkPpzVwRDkAhBZtJfHZMqETXEULaf5cKD13M=";
  };

  postPatch = ''
    substituteInPlace scripts/rescan-scsi-bus.sh \
      --replace-fail '/usr/bin/sg_' "$out/bin/sg_"
  '';

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

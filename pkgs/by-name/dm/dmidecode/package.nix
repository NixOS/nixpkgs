{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dmidecode";
  version = "3.7";

  src = fetchurl {
    url = "mirror://savannah/dmidecode/dmidecode-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-LDrtEshaHmqUENQG1eQXxFVGbcG8fIkni7Ms98rZHoo=";
  };

  makeFlags = [
    "prefix=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];
  outputs = [
    "out"
    "man"
    "doc"
  ];

  meta = {
    homepage = "https://www.nongnu.org/dmidecode/";
    description = "Tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})

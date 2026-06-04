{
  lib,
  stdenv,
  fetchurl,
  perl,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dos2unix";
  version = "7.5.5";

  src = fetchurl {
    url = "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-${finalAttrs.version}.tar.gz";
    hash = "sha256-dfaSuEhMjCRXmi/9h98WuclCjtlUl+M5OiHRugaXrDM=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    perl
    gettext
  ];
  makeFlags = [ "prefix=${placeholder "out"}" ];

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  meta = {
    description = "Convert text files with DOS or Mac line breaks to Unix line breaks and vice versa";
    homepage = "https://waterlan.home.xs4all.nl/dos2unix.html";
    changelog = "https://waterlan.home.xs4all.nl/dos2unix/ChangeLog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      sandarukasa
    ];
    platforms = lib.platforms.all;
  };
})

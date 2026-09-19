{
  lib,
  stdenv,
  fetchurl,
  perl,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dos2unix";
  version = "7.5.6";

  src = fetchurl {
    url = "https://waterlander.net/dos2unix/files/dos2unix-${finalAttrs.version}.tar.gz";
    hash = "sha256-Y2UKy9DH+oYjQpvL+TqIjjNRocrQ9VbPQYdvVnPdfQs=";
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
    homepage = "https://waterlander.net/dos2unix/";
    changelog = "https://waterlander.net/dos2unix/doc/ChangeLog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      sandarukasa
    ];
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenv,
  fetchurl,
  perl,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dos2unix";
  version = "7.5.7";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/dos2unix/dos2unix/${finalAttrs.version}/dos2unix-${finalAttrs.version}.tar.gz";
    hash = "sha256-Zp7icSCucVifY4/joWfW6lT4Yz9asbKCVRvXp8lRDfo=";
  };

  nativeBuildInputs = [
    perl
    gettext
  ];
  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = {
    description = "Convert text files with DOS or Mac line breaks to Unix line breaks and vice versa";
    homepage = "https://dos2unix.sourceforge.io/";
    changelog = "https://dos2unix.sourceforge.io/dos2unix/ChangeLog.txt";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})

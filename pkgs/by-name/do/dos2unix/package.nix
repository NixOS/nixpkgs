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
    urls = [
      "https://waterlander.net/dos2unix/files/dos2unix-${finalAttrs.version}.tar.gz"
      "mirror://sourceforge/project/dos2unix/dos2unix/${finalAttrs.version}/dos2unix-${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-dfaSuEhMjCRXmi/9h98WuclCjtlUl+M5OiHRugaXrDM=";
  };

  nativeBuildInputs = [
    perl
    gettext
  ];
  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = {
    description = "Convert text files with DOS or Mac line breaks to Unix line breaks and vice versa";
    homepage = "https://waterlander.net/dos2unix/";
    changelog = "https://sourceforge.net/p/dos2unix/dos2unix/ci/dos2unix-${finalAttrs.version}/tree/dos2unix/NEWS.txt?format=raw";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ highghlow ];
    platforms = lib.platforms.all;
  };
})

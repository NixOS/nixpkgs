{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  flex,
  bison,
  xmlto,
  docbook_xsl,
  docbook_xml_dtd_44,
  swig,
  perl,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "comedilib";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "Linux-Comedi";
    repo = "comedilib";
    rev = "r${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    sha256 = "0kfs2dw62vjz8j7fgsxq6ky8r8kca726gyklbm6kljvgfh47lyfw";
  };

  nativeBuildInputs = [
    autoreconfHook
    flex
    bison
    swig
    xmlto
    docbook_xml_dtd_44
    docbook_xsl
    python3
    perl
  ];

  preConfigure = ''
    patchShebangs --build doc/mkref doc/mkdr perl/Comedi.pm
  '';

  configureFlags = [
    "--with-udev-hotplug=${placeholder "out"}/lib"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  meta = with lib; {
    description = "Linux Control and Measurement Device Interface Library";
    homepage = "https://github.com/Linux-Comedi/comedilib";
    license = licenses.lgpl21;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.linux;
  };
})

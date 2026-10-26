{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidxml";
  version = "1.13";

  src = fetchurl {
    url = "mirror://sourceforge/rapidxml/rapidxml-${finalAttrs.version}.zip";
    sha256 = "0w9mbdgshr6sh6a5jr10lkdycjyvapbj7wxwz8hbp0a96y3biw63";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/include/${finalAttrs.pname}
    cp * $out/include/${finalAttrs.pname}
  '';

  meta = {
    description = "Fast XML DOM-style parser in C++";
    homepage = "https://rapidxml.sourceforge.net/";
    license = lib.licenses.boost;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})

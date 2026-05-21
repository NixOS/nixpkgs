{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libffcall";
  version = "2.5";

  src = fetchurl {
    url = "mirror://gnu/libffcall/libffcall-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-f0IglrQEmLE4kJOVWCXxQbtn7WAUJJ2IQAlGPceEaHk=";
  };

  enableParallelBuilding = false;

  outputs = [
    "dev"
    "out"
    "doc"
    "man"
  ];

  postInstall = ''
    mkdir -p $doc/share/doc/libffcall
    mv $out/share/html $doc/share/doc/libffcall
    rm -rf $out/share
  '';

  meta = {
    description = "Foreign function call library";
    homepage = "https://www.gnu.org/software/libffcall/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})

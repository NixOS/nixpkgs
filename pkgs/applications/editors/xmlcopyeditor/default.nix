{ lib
, stdenv
, fetchurl
, aspell
, boost
, expat
, intltool
, pkg-config
, libxml2
, libxslt
, pcre2
, wxGTK32
, xercesc
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "xmlcopyeditor";
  version = "1.3.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/xml-copy-editor/${pname}-${version}.tar.gz";
    sha256 = "sha256-6HHKl7hqyvF3gJ9vmjLjTT49prJ8KhEEV0qPsJfQfJE=";
  };

  patches = [ ./xmlcopyeditor.patch ];

  nativeBuildInputs = [
    intltool
    pkg-config
  ];

  buildInputs = [
    aspell
    boost
    expat
    libxml2
    libxslt
    pcre2
    wxGTK32
    xercesc
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A fast, free, validating XML editor";
    homepage = "https://xml-copy-editor.sourceforge.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ candeira wegank ];
  };
}

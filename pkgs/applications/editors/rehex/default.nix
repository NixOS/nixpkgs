{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, capstone
, jansson
, lua5_3
, wxGTK31
, Carbon
, Cocoa
, IOKit
, libicns
, wxmac
}:

stdenv.mkDerivation rec {
  pname = "rehex";
  version = "0.3.92";

  src = fetchFromGitHub {
    owner = "solemnwarning";
    repo = pname;
    rev = version;
    sha256 = "sha256-yZvJlomUpJwDJOBVSl49lU+JE1YMMs/BSzHepXoFlIY=";
  };

  postPatch = ''
    substituteInPlace Makefile.osx --replace 'iconutil -c icns -o $@ $(ICONSET)' \
      'png2icns $@ $(ICONSET)/icon_16x16.png $(ICONSET)/icon_32x32.png $(ICONSET)/icon_128x128.png $(ICONSET)/icon_256x256.png $(ICONSET)/icon_512x512.png'
  '';

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals stdenv.isDarwin [ libicns ];

  buildInputs = [ capstone jansson lua5_3 ]
    ++ lib.optionals (!stdenv.isDarwin) [ wxGTK31 ]
    ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa IOKit wxmac ];

  makeFlags = [ "prefix=$(out)" ]
    ++ lib.optionals stdenv.isDarwin [ "-f Makefile.osx" ];

  meta = with lib; {
    description = "Reverse Engineers' Hex Editor";
    longDescription = ''
      A cross-platform (Windows, Linux, Mac) hex editor for reverse
      engineering, and everything else.
    '';
    homepage = "https://github.com/solemnwarning/rehex";
    license = licenses.gpl2;
    maintainers = with maintainers; [ markus1189 SuperSandro2000 ];
    platforms = platforms.all;
  };
}

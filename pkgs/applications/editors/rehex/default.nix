{ lib, stdenv
, fetchFromGitHub
, capstone
, jansson
, wxGTK30
, darwin
, libicns
, wxmac
}:

stdenv.mkDerivation rec {
  pname = "rehex";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "solemnwarning";
    repo = pname;
    rev = version;
    sha256 = "1yj9a63j7534mmz8cl1ifg2wmgkxmk6z75jd8lkmc2sfrjbick32";
  };

  patchPhase = ''
    substituteInPlace Makefile.osx --replace 'iconutil -c icns -o $@ $(ICONSET)' \
      'png2icns $@ $(ICONSET)/icon_16x16.png $(ICONSET)/icon_32x32.png $(ICONSET)/icon_128x128.png $(ICONSET)/icon_256x256.png $(ICONSET)/icon_512x512.png'
  '';

  nativeBuildInputs = lib.optionals (stdenv.isDarwin) [ libicns ];

  buildInputs = [ capstone jansson ]
    ++ (lib.optionals (!stdenv.isDarwin) [ wxGTK30 ])
    ++ (lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Carbon Cocoa IOKit wxmac ]));

  makeFlags = [ "prefix=$(out)" ] ++ (lib.optionals stdenv.isDarwin [ "-f Makefile.osx" ]);

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

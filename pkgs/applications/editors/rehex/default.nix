{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, which
, zip
, libicns
, botan2
, capstone
, jansson
, libunistring
, wxGTK32
, lua53Packages
, perlPackages
, gtk3
, Carbon
, Cocoa
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "rehex";
  version = "0.61.1";

  src = fetchFromGitHub {
    owner = "solemnwarning";
    repo = pname;
    rev = version;
    hash = "sha256-/m4s5BW33I9g9hi5j3Vtui271w8Jv91+rQrI3qpO5Og=";
  };

  nativeBuildInputs = [ pkg-config which zip ]
    ++ lib.optionals stdenv.isDarwin [ libicns ];

  buildInputs = [ botan2 capstone jansson libunistring wxGTK32 ]
    ++ (with lua53Packages; [ lua busted ])
    ++ (with perlPackages; [ perl TemplateToolkit ])
    ++ lib.optionals stdenv.isLinux [ gtk3 ]
    ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa IOKit ];

  makeFlags = [ "prefix=${placeholder "out"}" ]
    ++ lib.optionals stdenv.isDarwin [ "-f Makefile.osx" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Reverse Engineers' Hex Editor";
    longDescription = ''
      A cross-platform (Windows, Linux, Mac) hex editor for reverse
      engineering, and everything else.
    '';
    homepage = "https://github.com/solemnwarning/rehex";
    changelog = "https://github.com/solemnwarning/rehex/raw/${version}/CHANGES.txt";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ markus1189 wegank ];
    platforms = platforms.all;
    mainProgram = "rehex";
  };
}

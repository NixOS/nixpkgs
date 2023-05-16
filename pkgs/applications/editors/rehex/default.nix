{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, which
, zip
, libicns
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
<<<<<<< HEAD
  version = "0.60.1";
=======
  version = "0.5.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "solemnwarning";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-oF8XtxKqyo6c2lNH6WDq6aEPeZw8RqBinDVhPpaDAWg=";
=======
    hash = "sha256-UgwCfy2ssaPuSWeN2SXHBDXv/uLdrDoGr/Q9wXiuCnc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config which zip ]
    ++ lib.optionals stdenv.isDarwin [ libicns ];

  buildInputs = [ capstone jansson libunistring wxGTK32 ]
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
  };
}

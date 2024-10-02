{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, which
, zip
, libicns
, botan3
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
  version = "0.62.1";

  src = fetchFromGitHub {
    owner = "solemnwarning";
    repo = pname;
    rev = version;
    hash = "sha256-RlYpg3aon1d25n8K/bbHGVLn5/iOOUSlvjT8U0fp9hA=";
  };

  nativeBuildInputs = [ pkg-config which zip ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libicns ];

  buildInputs = [ botan3 capstone jansson libunistring wxGTK32 ]
    ++ (with lua53Packages; [ lua busted ])
    ++ (with perlPackages; [ perl TemplateToolkit ])
    ++ lib.optionals stdenv.hostPlatform.isLinux [ gtk3 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Carbon Cocoa IOKit ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "BOTAN_PKG=botan-3"
    "CXXSTD=-std=c++20"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "-f Makefile.osx" ];

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

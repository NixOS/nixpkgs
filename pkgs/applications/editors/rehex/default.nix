{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, which
, capstone
, jansson
, libunistring
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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "solemnwarning";
    repo = pname;
    rev = version;
    hash = "sha256-NuWWaYABQDaS9wkwmXkBJWHzLFJbUUCiePNQNo4yZrk=";
  };

  postPatch = ''
    # See https://github.com/solemnwarning/rehex/pull/148
    substituteInPlace Makefile.osx \
      --replace '$(filter-out %@2x.png,$(wildcard $(ICONSET)/*.png))' 'res/icon{16,32,128,256,512}.png'
  '';

  nativeBuildInputs = [ pkg-config which ]
    ++ lib.optionals stdenv.isDarwin [ libicns ];

  buildInputs = [ capstone jansson libunistring lua5_3 ]
    ++ lib.optionals (!stdenv.isDarwin) [ wxGTK31 ]
    ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa IOKit wxmac ];

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
    maintainers = with maintainers; [ markus1189 ];
    platforms = platforms.all;
  };
}

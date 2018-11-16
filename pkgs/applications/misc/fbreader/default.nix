{ stdenv, fetchFromGitHub, pkgconfig
, bzip2, curl, expat, fribidi, libunibreak, sqlite, zlib
, uiTarget ? if !stdenv.isDarwin then "desktop" else "macosx"
, uiType ? if !stdenv.isDarwin then "qt4" else "cocoa"
, qt4, gtk2
, AppKit, Cocoa
}:

with stdenv.lib;

assert elem uiTarget [ "desktop" "macosx" ];
assert elem uiType [ "qt4" "gtk" "cocoa" ];
assert uiTarget == "macosx" -> uiType == "cocoa";

# Note: "qt" uiType option mentioned in ${src}/README.build is qt3,
# which is way to old and no longer in nixpkgs.

stdenv.mkDerivation {
  name = "fbreader-${uiType}-0.99.6";

  src = fetchFromGitHub {
    owner = "geometer";
    repo = "FBReader";
    rev = "9e608db14372ae580beae4976eec7241fa069e75";
    sha256 = "0lzafk02mv0cf2l2a61q5y4743zi913byik4bw1ix0gr1drnsa7y";
  };

  patches = [ ./typecheck.patch ];

  postPatch = ''
    cat << EOF > makefiles/target.mk
    TARGET_ARCH = ${uiTarget}
    TARGET_STATUS = release
    UI_TYPE = ${uiType}
    EOF

    substituteInPlace makefiles/arch/desktop.mk \
      --replace ccache "" \
      --replace moc-qt4 moc

    # libunibreak supersedes liblinebreak
    substituteInPlace zlibrary/text/Makefile \
      --replace -llinebreak -lunibreak
  '';

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    bzip2 curl expat fribidi libunibreak sqlite zlib
  ]
  ++ optional (uiType == "qt4") qt4
  ++ optional (uiType == "gtk") gtk2
  ++ optionals (uiType == "cocoa") [ AppKit Cocoa ];

  makeFlags = "INSTALLDIR=$(out)";

  NIX_CFLAGS_COMPILE = [ "-Wno-error=narrowing" ]; # since gcc-6

  meta = with stdenv.lib; {
    description = "An e-book reader for Linux";
    homepage = http://www.fbreader.org/;
    license = licenses.gpl3;
    broken = stdenv.isDarwin  # untested, might work
          || uiType == "gtk"; # builds, but the result is unusable, hangs a lot
    platforms = platforms.unix;
    maintainers = [ maintainers.coroa ];
  };
}

{ mkDerivation
, lib
, fetchFromGitHub
, fetchpatch

, anthy
, hunspell
, libchewing
, libpinyin
, maliit-framework
, pcre
, qtmultimedia
, qtquickcontrols2
, qtgraphicaleffects

, cmake
, pkgconfig
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "maliit-keyboard";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "maliit";
    repo = "keyboard";
    rev = version;
    sha256 = "10dh0abxq90024dqq3fs8mjxww3igb4l09d19i2fq9f3flvh11hc";
  };

  patches = [
    (fetchpatch {
      # https://github.com/maliit/keyboard/pull/34
      url = "https://github.com/maliit/keyboard/commit/9848a73b737ad46b5790ebf713a559d340c91b82.patch";
      sha256 = "0qrsga0npahjrgbl6mycvl6d6vjm0d17i5jadcn7y6khbhq2y6rg";
    })
  ];

  postPatch = ''
    substituteInPlace data/schemas/org.maliit.keyboard.maliit.gschema.xml \
      --replace /usr/share "$out/share"
  '';

  buildInputs = [
    # TODO: package https://github.com/qt/qtfeedback
    anthy
    hunspell
    libchewing
    libpinyin
    maliit-framework
    pcre
    qtmultimedia
    qtquickcontrols2
    qtgraphicaleffects
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    # FIXME package presage
    "-Denable-presage=OFF"
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig
    wrapGAppsHook
  ];

  postInstall = ''
    glib-compile-schemas "$out"/share/glib-2.0/schemas
  '';

  meta = with lib; {
    description = "Virtual keyboard";
    homepage = "http://maliit.github.io/";
    license = with licenses; [ lgpl3Only bsd3 cc-by-30 ];
    maintainers = with maintainers; [ samueldr ];
  };
}

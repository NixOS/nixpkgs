{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kakasi";
  version = "2.3.6";

  src = fetchurl {
    url = "http://kakasi.namazu.org/stable/kakasi-${finalAttrs.version}.tar.xz";
    hash = "sha256-LuV7GwPHT9V2bnQcOBICjvxzvA4L+Tpuf/IOtHAfPuM=";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/kakasi/raw/4756771/f/kakasi-configure-c99.patch";
      hash = "sha256-XPIp/+AR6K84lv606aRHPQwia/1K3rt/7KSo0V0ZQ5o=";
    })
    ./gettext-0.25.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  env = lib.optionalAttrs (!stdenv.cc.isClang) {
    NIX_CFLAGS_COMPILE = "-std=gnu17";
  };

  postPatch = ''
    for a in tests/kakasi-* ; do
      substituteInPlace $a \
        --replace-quiet "/bin/echo" echo
    done
  '';

  doCheck = false; # fails 1 of 6 tests

  meta = {
    description = "Kanji Kana Simple Inverter";
    longDescription = ''
      KAKASI is the language processing filter to convert Kanji
      characters to Hiragana, Katakana or Romaji and may be
      helpful to read Japanese documents.
    '';
    homepage = "http://kakasi.namazu.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})

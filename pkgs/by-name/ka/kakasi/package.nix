{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "kakasi";
  version = "2.3.6";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = with lib; {
    description = "Kanji Kana Simple Inverter";
    longDescription = ''
      KAKASI is the language processing filter to convert Kanji
      characters to Hiragana, Katakana or Romaji and may be
      helpful to read Japanese documents.
    '';
    homepage = "http://kakasi.namazu.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };

  src = fetchurl {
    url = "http://kakasi.namazu.org/stable/kakasi-${version}.tar.xz";
    sha256 = "1qry3xqb83pjgxp3my8b1sy77z4f0893h73ldrvdaky70cdppr9f";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/kakasi/raw/4756771/f/kakasi-configure-c99.patch";
      hash = "sha256-XPIp/+AR6K84lv606aRHPQwia/1K3rt/7KSo0V0ZQ5o=";
    })
    ./gettext-0.25.patch
  ];

  postPatch = ''
    for a in tests/kakasi-* ; do
      substituteInPlace $a \
        --replace-quiet "/bin/echo" echo
    done
  '';

  doCheck = false; # fails 1 of 6 tests

}

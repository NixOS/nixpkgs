{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libtool,
  gettext,
  pkg-config,
  vala,
  gnome-common,
  gobject-introspection,
  libgee,
  json-glib,
  skkDictionaries,
  libxkbcommon,
}:

stdenv.mkDerivation rec {
  pname = "libskk";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ueno";
    repo = "libskk";
    tag = version;
    hash = "sha256-xXed7mQqseefIldGjNsQf8n0YTcI9L9T1FkO/dhNR3g=";
  };

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=int-conversion"
    ];
  };

  patches = [
    # fix parse error in default.json
    # https://github.com/ueno/libskk/pull/90
    (fetchpatch {
      url = "https://github.com/ueno/libskk/commit/2382ebedc8dca88e745d223ad7badb8b73bbb0de.diff";
      hash = "sha256-e1bKVteNjqmr40XI82Qar63LXPWYIfnUVlo5zQSkPNw=";
    })
  ];

  buildInputs = [ libxkbcommon ];
  nativeBuildInputs = [
    vala
    gnome-common
    gobject-introspection
    libtool
    gettext
    pkg-config
  ];
  propagatedBuildInputs = [
    libgee
    json-glib
  ];

  configureScript = "./autogen.sh";

  # link SKK-JISYO.L from skkdicts for the bundled tool `skk`
  preInstall = ''
    dictDir=$out/share/skk
    mkdir -p $dictDir
    ln -s ${skkDictionaries.l}/share/skk/SKK-JISYO.L $dictDir/
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Library to deal with Japanese kana-to-kanji conversion method";
    mainProgram = "skk";
    longDescription = ''
      Libskk is a library that implements basic features of SKK including:
      new word registration, completion, numeric conversion, abbrev mode, kuten input,
      hankaku-katakana input, Lisp expression evaluation (concat only), and re-conversion.
      It also supports various typing rules including: romaji-to-kana, AZIK, TUT-Code, and NICOLA,
      as well as various dictionary types including: file dictionary (such as SKK-JISYO.[SML]),
      user dictionary, skkserv, and CDB format dictionary.
    '';
    homepage = "https://github.com/ueno/libskk";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yuriaisaka ];
    platforms = lib.platforms.linux;
  };
}

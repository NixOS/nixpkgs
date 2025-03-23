{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  autoreconfHook,
  glib,
  db,
  pkg-config,
}:

let
  modelData = fetchurl {
    url = "mirror://sourceforge/libpinyin/models/model20.text.tar.gz";
    hash = "sha256-WcaOidQ/+F9aMJSJSZy83igtKwS9kYiHNIhLfe/LEVU=";
  };
in
stdenv.mkDerivation rec {
  pname = "libpinyin";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "libpinyin";
    tag = version;
    hash = "sha256-WUC1l+8q4TYDVbKwwk9lG5Wc5DM52BaZefcre0WQoBE=";
  };

  postUnpack = ''
    tar -xzf ${modelData} -C $sourceRoot/data
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    db
  ];

  meta = {
    description = "Library for intelligent sentence-based Chinese pinyin input method";
    homepage = "https://github.com/libpinyin/libpinyin";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      linsui
      ericsagnes
    ];
    platforms = lib.platforms.linux;
  };
}

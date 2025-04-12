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
    url = "mirror://sourceforge/libpinyin/models/model19.text.tar.gz";
    sha256 = "02zml6m8sj5q97ibpvaj9s9yz3gfj0jnjrfhkn02qv4nwm72lhjn";
  };
in
stdenv.mkDerivation rec {
  pname = "libpinyin";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "libpinyin";
    rev = version;
    hash = "sha256-3+CBbjCaY0Ubyphf0uCfYvF2rtc9fF1eEAM1doonjHg=";
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

  meta = with lib; {
    description = "Library for intelligent sentence-based Chinese pinyin input method";
    homepage = "https://github.com/libpinyin/libpinyin";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      linsui
      ericsagnes
    ];
    platforms = platforms.linux;
  };
}

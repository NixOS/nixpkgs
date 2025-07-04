{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  autoreconfHook,
  glib,
  db,
  pkg-config,
  nix-update-script,
}:

let
  modelData = fetchurl {
    url = "mirror://sourceforge/libpinyin/models/model20.text.tar.gz";
    hash = "sha256-WcaOidQ/+F9aMJSJSZy83igtKwS9kYiHNIhLfe/LEVU=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libpinyin";
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "libpinyin";
    tag = finalAttrs.version;
    hash = "sha256-EexmZFGvuMextbiMZ6mSV58UUUjVVGMQubtS6DzoBs0=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library for intelligent sentence-based Chinese pinyin input method";
    homepage = "https://github.com/libpinyin/libpinyin";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      linsui
    ];
    platforms = lib.platforms.linux;
  };
})

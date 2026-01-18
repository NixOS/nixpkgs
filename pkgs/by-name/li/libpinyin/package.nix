{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  autoreconfHook,
  glib,
  kyotocabinet,
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
  version = "2.11.91";

  src = fetchFromGitHub {
    owner = "libpinyin";
    repo = "libpinyin";
    tag = finalAttrs.version;
    hash = "sha256-MXM+iGCtF8gTpRnT0Xi8s+kqsOkGLXY06R8MME2icWo=";
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
    kyotocabinet
  ];

  configureFlags = [
    "--with-dbm=KyotoCabinet"
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

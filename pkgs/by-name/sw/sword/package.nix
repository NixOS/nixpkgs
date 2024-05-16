{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  icu,
  clucene_core,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sword";
  version = "1.9.0";

  src = fetchurl {
    url = "https://www.crosswire.org/ftpmirror/pub/sword/source/v${lib.versions.majorMinor finalAttrs.version}/sword-${finalAttrs.version}.tar.gz";
    hash = "sha256-QkCc894vrxEIUj4sWsB0XSH57SpceO2HjuncwwNCa4o=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    icu
    clucene_core
    curl
  ];

  outputs = [
    "out"
    "dev"
  ];

  prePatch = ''
    patchShebangs .;
  '';

  configureFlags = [
    "--without-conf"
    "--enable-tests=no"
  ];

  CXXFLAGS = [
    "-Wno-unused-but-set-variable"
    "-Wno-unknown-warning-option"
    # compat with icu61+ https://github.com/unicode-org/icu/blob/release-64-2/icu4c/readme.html#L554
    "-DU_USING_ICU_NAMESPACE=1"
  ];

  meta = {
    description = "Software framework that allows research manipulation of Biblical texts";
    homepage = "https://www.crosswire.org/sword/";
    longDescription = ''
      The SWORD Project is the CrossWire Bible Society's free Bible software
      project. Its purpose is to create cross-platform open-source tools --
      covered by the GNU General Public License -- that allow programmers and
      Bible societies to write new Bible software more quickly and easily. We
      also create Bible study software for all readers, students, scholars, and
      translators of the Bible, and have a growing collection of many hundred
      texts in around 100 languages.
    '';
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})

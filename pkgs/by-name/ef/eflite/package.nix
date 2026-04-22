{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  flite,
  alsa-lib,
  debug ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eflite";
  version = "0.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/eflite/eflite/${finalAttrs.version}/eflite-${finalAttrs.version}.tar.gz";
    hash = "sha256-ka2FhV5Vo/w7l6GlJdtf0dIR1UNCu/yI0QJoExBPFyE=";
  };

  buildInputs = [
    flite
    alsa-lib
  ];

  configureFlags = [
    "flite_dir=${flite.dev}"
    "--with-audio=alsa"
    "--with-vox=cmu_us_kal16"
  ];

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/e/eflite/0.4.1-14/debian/patches/cvs-update";
      hash = "sha256-BcgBZCbXWOaM4cSPeDPuIDviTymihAo9Puv4Wf8Ow2Q=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/e/eflite/0.4.1-14/debian/patches/link";
      hash = "sha256-zAEJl473sk1H6Ltbbeo9IhWE5/Z6QL7EUV63S24bA10=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/e/eflite/0.4.1-14/debian/patches/buf-overflow";
      hash = "sha256-vc6dn4x0ortRp8TqHgNl0Ki10h3w9WnwOvasOUaYOBw=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/e/eflite/0.4.1-14/debian/patches/flags";
      hash = "sha256-h7+OewOznlOrGNcn2zfE4kb/0rP+h9rTP3TLlyiPTJM=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/e/eflite/0.4.1-14/debian/patches/gcc-15";
      hash = "sha256-hiQaEM9Rf0KV8rgkXdjj3KIF+4jMYS4J4CT4UIfydGQ=";
    })
    ./format.patch
  ];

  env = lib.optionalAttrs debug {
    CFLAGS = " -DDEBUG=2";
  };

  meta = {
    homepage = "https://eflite.sourceforge.net";
    description = "Speech server for screen readers";
    longDescription = ''
      EFlite is a speech server for Emacspeak and other screen
      readers that allows them to interface with Festival Lite,
      a free text-to-speech engine developed at the CMU Speech
      Center as an off-shoot of Festival.
    '';
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "eflite";
  };
})

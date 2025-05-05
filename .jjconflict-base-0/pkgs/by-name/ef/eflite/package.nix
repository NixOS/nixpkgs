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
      url = "https://sources.debian.org/data/main/e/eflite/0.4.1-8/debian/patches/cvs-update";
      sha256 = "0r631vzmky7b7qyhm152557y4fr0xqrpi3y4w66fcn6p4rj03j05";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/e/eflite/0.4.1-8/debian/patches/buf-overflow";
      sha256 = "071qk133kb7n7bq6kxgh3p9bba6hcl1ixsn4lx8vp8klijgrvkmx";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/e/eflite/0.4.1-8/debian/patches/link";
      sha256 = "0p833dp4pdsya72bwh3syvkq85927pm6snxvx13lvcppisbhj0fc";
    })
    ./format.patch
  ];

  CFLAGS = lib.optionalString debug " -DDEBUG=2";

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

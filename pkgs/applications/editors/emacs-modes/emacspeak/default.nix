{ stdenv, fetchurl, makeWrapper, emacs, texinfo, tcl, tk, tclx
, espeakTTS ? true, espeak ? null
, outLoudTTS ? false, glibc_multi ? null, alsaLib ? null
, decTalkTTS ? false}:

assert espeakTTS -> espeak != null;

assert outLoudTTS -> glibc_multi != null;
assert outLoudTTS -> alsaLib != null;
assert outLoudTTS -> false; # Could not get it to work

assert decTalkTTS -> false; # Could not get it to work

stdenv.mkDerivation rec {
  name = "emacspeak-${version}";
  version = "44.0";

  src = fetchurl {
    url = "https://github.com/tvraman/emacspeak/releases/download/44.0/${name}.tar.bz2";
    sha256 = "1mbgfcd2hk8xya85cx7zwd4k5zn2lqqqqmqpc35860ljsm58zspq";
  };

  tclLibraries = [ tclx tk ];
  tclLibPaths = stdenv.lib.concatStringsSep " "
    (map (p: "${p}/lib/${p.libPrefix}") tclLibraries);

  buildInputs = [ makeWrapper emacs texinfo
                  espeak glibc_multi alsaLib
                  tcl ] ++ tclLibraries;

  configurePhase = ''
    make config

    ${if espeakTTS then "" else
      "sed '/INSTALL.*ESPEAK/d' -i Makefile"}
    ${if outLoudTTS then "" else
      "sed '/INSTALL.*OUTLOUD/d' -i Makefile"}
    ${if decTalkTTS then "" else
      "sed '/INSTALL.*DTKTTS/d' -i Makefile"}
  '';

  buildPhase = ''
    make

    ${if espeakTTS then
      "(cd servers/linux-espeak;
        make)"
    else ""}
    ${if outLoudTTS then
      "(cd servers/linux-outloud;
        make)"
    else ""}
    ${if decTalkTTS then
      "(cd servers/software-dtk;
        make)"
    else ""}
  '';

  installPhase = ''
    make prefix=$out SRC=$out/share/emacs/site-lisp/emacspeak install

    ${if espeakTTS then
      "(cd servers/linux-espeak;
        make PREFIX=$out install)"
    else ""}
    ${if outLoudTTS then
      "(cd servers/linux-outloud;
        make PREFIX=$out install)"
    else ""}
    ${if decTalkTTS then
      "(cd servers/software-dtk;
        make PREFIX=$out install)"
    else ""}

    for prog in `grep -rl '^#!/usr/bin/tclsh' $out`; do
      wrapProgram "$prog" --set TCLLIBPATH '"${tclLibPaths}"'
    done
  '';

  meta = {
    description = "Speech mode for Emacs";
    homepage = http://emacspeak.sourceforge.net;
    license     = stdenv.lib.licenses.gpl2Plus;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ kovirobi ];
  };
}

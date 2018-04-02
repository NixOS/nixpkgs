{ stdenv, fetchurl, makeWrapper, emacs, texinfo, tcl, tk, tclx
, espeakTTS ? true, espeak-classic ? null
, outLoudTTS ? false, glibc_multi ? null, alsaLib ? null
, decTalkTTS ? false}:

assert espeakTTS -> espeak-classic != null;

assert outLoudTTS -> glibc_multi != null;
assert outLoudTTS -> alsaLib != null;
assert outLoudTTS -> false; # Could not get it to work
assert decTalkTTS -> false; # Could not get it to work

stdenv.mkDerivation rec {
  name = "emacspeak-${version}";
  version = "47.0";

  src = fetchurl {
    url = "https://github.com/tvraman/emacspeak/releases/download/${version}/${name}.tar.bz2";
    sha256 = "0xbcc266x752y68s3g096m161irzvsqym3axzqn8rb276a8x55n7";
  };

  tclLibraries = [ tclx tk ];
  tclLibPaths = stdenv.lib.concatStringsSep " "
    (map (p: "${p}/lib/${p.libPrefix}") tclLibraries);

  buildInputs = [ 
    makeWrapper
    emacs
    texinfo
    espeak-classic
    glibc_multi
    alsaLib
    tcl
  ] ++ tclLibraries;

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
    mkdir $out
    cp -R * $out

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
      wrapProgram "$prog" --set TCLLIBPATH "${tclLibPaths}"
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

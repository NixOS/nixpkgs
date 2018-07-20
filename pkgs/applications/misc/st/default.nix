{ stdenv, fetchpatch, fetchurl, pkgconfig, writeText, makeWrapper, libX11, ncurses, libXext
, libXft, fontconfig, dmenu, conf ? null, patches ? [], extraLibs ? []
, withAlpha ? false, withClipboard ? false, withHidecursor ? false,  }:

with stdenv.lib;

let patches' = if patches == null then [] else patches;
in stdenv.mkDerivation rec {
  name = "st-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "https://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "09k94v3n20gg32xy7y68p96x9dq5msl80gknf9gbvlyjp3i0zyy4";
  };

  alphaPatch = fetchpatch {
    name = "st-alpha.patch";
    url = "https://st.suckless.org/patches/alpha/st-alpha-${version}.diff";
    sha256 = "18iw0bzmagcchlf5m5dfvdryn47kpdbcs1j1waq8vl1w2wvcg5al";
  };

  clipboardPatch = fetchpatch {
    name = "clipboard.patch";
    url = "https://st.suckless.org/patches/clipboard/st-clipboard-${version}.diff";
    sha256 = "0gdjgzg2a98fph4sn4w210p39401mm4imkrllfyhc836bjyhi5pc";
  };

  hidecursorPatch = fetchpatch {
    name = "hidecursor.patch";
    url = "https://st.suckless.org/patches/hidecursor/st-hidecursor-${version}.diff";
    sha256 = "02b4h375c2vd79f7cagki5fnx1ipygywlxn25c62kg529d7zfck0";
  };

  patches = optional withAlpha alphaPatch
    ++ optional withClipboard clipboardPatch
    ++ optional withHidecursor hidecursorPatch
    ++ patches';

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ libX11 ncurses libXext libXft fontconfig ] ++ extraLibs;

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
    wrapProgram "$out/bin/st" --prefix PATH : "${dmenu}/bin"
  '';

  meta = {
    homepage = https://st.suckless.org/;
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [viric andsild koral];
    platforms = platforms.linux;
  };
}

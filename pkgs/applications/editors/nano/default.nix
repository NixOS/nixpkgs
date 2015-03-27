{ stdenv, fetchurl
, ncurses
, gettext ? null
, enableNls ? true
, enableTiny ? false
}:

assert enableNls -> (gettext != null);

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "nano-${version}";
  version = "2.4.0";
  src = fetchurl {
    url = "mirror://gnu/nano/${name}.tar.gz";
    sha256 = "1gbm9bcv4k55y01r5q8a8a9s3yrrgq3z5jxxiij3wl404r8gnxjh";
  };
  buildInputs = [ ncurses ] ++ optional enableNls gettext;
  configureFlags = ''
    --sysconfdir=/etc
    ${optionalString (!enableNls) "--disable-nls"}
    ${optionalString enableTiny "--enable-tiny"}
  '';

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/text.c --replace "__time_t" "time_t"
  '';

  meta = {
    homepage = http://www.nano-editor.org/;
    description = "A small, user-friendly console text editor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ joachifm ];
    platforms = platforms.all;
  };
}

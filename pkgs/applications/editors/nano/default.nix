{ stdenv, fetchurl
, ncurses
, texinfo
, gettext ? null
, enableNls ? true
, enableTiny ? false
}:

assert enableNls -> (gettext != null);

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "nano-${version}";
  version = "2.7.3";
  src = fetchurl {
    url = "mirror://gnu/nano/${name}.tar.xz";
    sha256 = "1z0bfyc5cvv83l3bjmlcwl49mpxrp65k5ffsfpnayfyjc18fy9nr";
  };
  nativeBuildInputs = [ texinfo ] ++ optional enableNls gettext;
  buildInputs = [ ncurses ];
  outputs = [ "out" "info" ];
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
    maintainers = with maintainers; [
      jgeerds
      joachifm
    ];
    platforms = platforms.all;
  };
}

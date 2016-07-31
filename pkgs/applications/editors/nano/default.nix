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
  version = "2.6.2";
  src = fetchurl {
    url = "https://nano-editor.org/dist/v2.6/${name}.tar.gz";
    sha256 = "11c9iqiah4q7q3ndn7z9192a796vp4fffkg27s6q1dn8avp06dj5";
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
    maintainers = with maintainers; [ joachifm ];
    platforms = platforms.all;
  };
}

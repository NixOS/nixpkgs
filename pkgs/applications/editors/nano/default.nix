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
  version = "2.6.3";
  src = fetchurl {
    url = "https://nano-editor.org/dist/v2.6/${name}.tar.gz";
    sha256 = "00ym3zws1vdds726drgr5wj14mjn18d96ghn6vjci0915zhm8h2g";
  };
  nativeBuildInputs = [ texinfo ] ++ optional enableNls gettext;
  buildInputs = [ ncurses ];
  outputs = [ "out" "info" ];
  configureFlags = ''
    --sysconfdir=/etc
    ${optionalString (!enableNls) "--disable-nls"}
    ${optionalString enableTiny "--enable-tiny"}
  '';

  patchFlags = [ "-p0" ];

  patches = optional stdenv.isDarwin
    (fetchurl {
      name = "darwin.patch";
      url = "https://trac.macports.org/browser/trunk/dports/editors/nano/files/patch-src-winio.c.diff?rev=151356&format=txt";
      sha256 = "184q33irz9px2svwr2qx70zvfby5zlwlhv4k607yzsy90fq2jpdd";
    });

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

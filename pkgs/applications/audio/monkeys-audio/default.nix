{lib, gcc10Stdenv, fetchurl}:

gcc10Stdenv.mkDerivation rec {
  version = "3.99-u4-b5";
  pname = "monkeys-audio-old";

  patches = [ ./buildfix.diff ];

  src = fetchurl {
    /*
    The real homepage is <https://monkeysaudio.com/>, but in fact we are
    getting an old, ported to Linux version of the sources, made by (quoting
    from the AUTHORS file found in the source):

    Frank Klemm : First port to linux (with makefile)

    SuperMMX <SuperMMX AT GMail DOT com> : Package the source, include the frontend and shared lib,
         porting to Big Endian platform and adding other non-win32 enhancement.
    */
    url = "https://deb-multimedia.org/pool/main/m/${pname}/${pname}_${version}.orig.tar.gz";
    sha256 = "0kjfwzfxfx7f958b2b1kf8yj655lp0ppmn0sh57gbkjvj8lml7nz";
  };

  meta = with lib; {
    description = "Lossless audio codec";
    platforms = platforms.linux;
    # This is not considered a GPL license, but it seems rather free although
    # it's not standard, see a quote of it:
    # https://github.com/NixOS/nixpkgs/pull/171682#issuecomment-1120260551
    license = licenses.free;
    maintainers = [ ];
  };
}

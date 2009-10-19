{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lame-3.98.2";
  src = fetchurl {
    url = mirror://sourceforge/lame/lame-398-2.tar.gz;
    sha256 = "0cmgr515szd9kd19mpzvwl3cbnpfyjyi47swj4afblcfkmb2hym1";
  };

  # Either disable static, or fix the rpath of 'lame' for it to point
  # properly to the libmp3lame shared object.
  dontDisableStatic = true;
}

{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "svox-${version}";
  version = "2016-10-20";

  src = fetchgit {
    url = "https://android.googlesource.com/platform/external/svox";
    rev = "2dd8f16e4436520b93e93aa72b92acad92c0127d";
    sha256 = "064h3zb9bn1z6xbv15iy6l4rlxx8fqzy54s898qvafjhz6kawj9g";
  };

  postPatch = ''
    cd pico
  '';

  buildPhase = ''
    cd lib
    for i in *.c; do
      $CC -O2 -fPIC -c -o ''${i%.c}.o $i
    done
    $CC -shared -o libttspico.so *.o
    cd ..
  '';

  installPhase = ''
    install -Dm755 lib/libttspico.so $out/lib/libttspico.so
    mkdir -p $out/include
    cp lib/*.h $out/include
    mkdir -p $out/share/pico/lang
    cp lang/*.bin $out/share/pico/lang
  '';

  NIX_CFLAGS_COMPILE = [ "-include stdint.h" ];

  meta = with stdenv.lib; {
    description = "Text-to-speech engine";
    homepage = "https://android.googlesource.com/platform/external/svox";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}

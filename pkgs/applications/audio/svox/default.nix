{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "svox-${version}";
  version = "2017-07-18";

  src = fetchgit {
    url = "https://android.googlesource.com/platform/external/svox";
    rev = "7e68d0e9aac1b5d2ad15e92ddaa3bceb27973fcb";
    sha256 = "1bqj12w23nn27x64ianm2flrqvkskpvgrnly7ah8gv6k8s8chh3r";
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
    homepage = https://android.googlesource.com/platform/external/svox;
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}

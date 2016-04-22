{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "svox-${version}";
  version = "2016-01-25";

  src = fetchgit {
    url = "https://android.googlesource.com/platform/external/svox";
    rev = "dfb9937746b1828d093faf3b1494f9dc403f392d";
    sha256 = "1gkfj5avikzmr2vv8bhf83n15jcbz4phz5j13l0qnh3gjzh4f1bk";
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

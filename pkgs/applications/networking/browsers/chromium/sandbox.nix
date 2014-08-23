{ stdenv, source }:

stdenv.mkDerivation {
  name = "chromium-sandbox-${source.version}";
  src = source.sandbox;

  patchPhase = ''
    sed -i -e '/#include.*base_export/c \
      #define BASE_EXPORT __attribute__((visibility("default")))
    /#include/s|sandbox/linux|'"$(pwd)"'/linux|
    ' linux/suid/*.[hc]
  '';

  buildPhase = ''
    gcc -Wall -std=gnu99 -o sandbox linux/suid/*.c
  '';

  installPhase = ''
    install -svD sandbox "$out/bin/chromium-sandbox"
  '';
}

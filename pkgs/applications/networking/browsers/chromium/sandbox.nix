{ stdenv, src, binary }:

stdenv.mkDerivation {
  name = "chromium-sandbox-${src.version}";
  inherit src;

  patchPhase = ''
    sed -i -e '/#include.*base_export/c \
      #define BASE_EXPORT __attribute__((visibility("default")))
    ' linux/suid/*.[hc]
  '';

  buildPhase = ''
    gcc -Wall -std=gnu99 -o sandbox linux/suid/*.c
  '';

  installPhase = ''
    install -svD sandbox "$out/bin/${binary}"
  '';
}

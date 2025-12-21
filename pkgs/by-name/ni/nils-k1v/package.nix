{
  stdenvNoCC,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  SDL2,
  cairo,
  libxcb-util,
  libxcb-cursor,

  installVST3 ? true,
  installVST2 ? true,
}:
stdenvNoCC.mkDerivation {
  pname = "nils-k1v";
  version = "1.26";

  src = fetchurl {
    url = "https://archive.org/download/nils-k1v-1.26/NilsK1v-x86_64.deb";
    hash = "sha256-uRwUXRUK/MBaQSxF6ERKAsP/3m8W1gom6aqUFfqBV0o=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    SDL2
    cairo
    libxcb-util
    libxcb-cursor
  ];

  installPhase = ''
    dpkg -x $src .

    pushd usr/local/lib/lxvst
      ${lib.optionalString installVST3 ''
        mkdir -p $out/lib/vst3
        install -Dm755 libNilsK1vVST3.vst3 $out/lib/vst3/libNilsK1vVST3.so
      ''}

      ${lib.optionalString installVST2 ''
        mkdir -p $out/lib/vst
        install -Dm755 libNilsK1vVST2.so $out/lib/vst
      ''}
    popd
  '';

  meta = {
    description = "Kawai K1 Emulation Plugin";
    homepage = "https://www.nilsschneider.de/wp/nils-k1v";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
}

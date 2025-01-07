{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "mystem";
  version = "3.1";

  src = fetchurl {
    url = "http://download.cdn.yandex.net/mystem/${pname}-${version}-linux-64bit.tar.gz";
    sha256 = "0qha7jvkdmil3jiwrpsfhkqsbkqn9dzgx3ayxwjdmv73ikmg95j6";
  };

  buildCommand = ''
    tar -xaf "$src"
    mkdir -p $out/bin
    install -Dm755 mystem $out/bin/mystem
    patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) $out/bin/mystem
  '';

  meta = {
    description = "Morphological analysis of Russian text";
    homepage = "https://yandex.ru/dev/mystem/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ abbradar ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mystem";
  };
}

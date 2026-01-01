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

<<<<<<< HEAD
  meta = {
    description = "Morphological analysis of Russian text";
    homepage = "https://yandex.ru/dev/mystem/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
=======
  meta = with lib; {
    description = "Morphological analysis of Russian text";
    homepage = "https://yandex.ru/dev/mystem/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mystem";
  };
}

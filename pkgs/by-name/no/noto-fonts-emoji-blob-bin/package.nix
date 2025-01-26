{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "noto-fonts-emoji-blob-bin";
  version = "15.0";

  src = fetchurl {
    url = "https://github.com/C1710/blobmoji/releases/download/v${version}/Blobmoji.ttf";
    hash = "sha256-3MPWZ1A2ups171dNIiFTJ3C1vZiGy6I8ZF70aUfrePk=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm 444 $src $out/share/fonts/blobmoji/Blobmoji.ttf
    runHook postInstall
  '';

  meta = {
    description = "Noto Emoji with extended Blob support";
    homepage = "https://github.com/C1710/blobmoji";
    license = with lib.licenses; [
      ofl
      asl20
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      rileyinman
      jk
    ];
  };
}

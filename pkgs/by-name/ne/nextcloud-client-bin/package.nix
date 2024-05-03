{ p7zip
, libarchive
, stdenvNoCC
, lib
, fetchurl
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nextcloud-client-bin";
  version = "3.13.0";

  src = fetchurl {
    url = "https://github.com/nextcloud-releases/desktop/releases/download/v${finalAttrs.version}/Nextcloud-${finalAttrs.version}.pkg";
    hash = "sha256-xqrOJxkFCQcTN7N0ZEjT85zn+u/o/fJUMZdaMBizls0=";
  };

  unpackPhase = ''
    7z x $src
    bsdtar -xf Payload~
  '';

  nativeBuildInputs = [
    p7zip
    libarchive
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R Applications/Nextcloud.app $out/Applications

    runHook postInstall
  '';

  meta = {
    homepage = "https://nextcloud.com";
    description = "Desktop Client for Nextcloud";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ArkieSoft ];
    platforms = lib.platforms.darwin;
    mainProgram = "nextcloud";
  };
})

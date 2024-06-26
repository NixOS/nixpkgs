{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cyberduck";
  version = "8.6.0.39818";

  src = fetchurl {
    url = "https://update.cyberduck.io/Cyberduck-${finalAttrs.version}.zip";
    sha256 = "1iqq54n267lmmdlv8wmr9k461p49jindc1mn5wy742k08cqxc5ab";
  };
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  meta = with lib; {
    description = "Libre file transfer client for Mac and Windows";
    homepage = "https://cyberduck.io";
    license = licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      emilytrau
      Enzime
    ];
    platforms = platforms.darwin;
  };
})

{
  dpkg,
  fetchurl,
  lib,
  stdenvNoCC,
  writeShellApplication,
  common-updater-scripts,
  curl,
  jc,
  jq,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plasticscm-theme";
  version = "11.0.16.9890";

  src = fetchurl {
    url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-theme_${finalAttrs.version}_amd64.deb";
    hash = "sha256-qxOzt+cylEt0kCKb7n+fd4Ut9R4KxYArUm9Ntxe4yVU=";
    nativeBuildInputs = [ dpkg ];
    downloadToTemp = true;
    recursiveHash = true;
    postFetch = ''
      mkdir -p $out
      dpkg-deb --fsys-tarfile $downloadedFile | tar --extract --directory=$out
      rm -rf $out/usr/share/doc
    '';
  };

  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt usr/share $out

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-plasticscm-theme";
    runtimeInputs = [
      common-updater-scripts
      curl
      dpkg
      jc
      jq
    ];
    text = ''
      version="$(curl -sSL https://www.plasticscm.com/plasticrepo/stable/debian/Packages |
        jc --pkg-index-deb |
        jq -r '[.[] | select(.package == "plasticscm-theme")] | sort_by(.version) | last | .version')"

      update-source-version --ignore-same-hash plasticscm-theme "$version"
    '';
  });

  meta = {
    homepage = "https://www.plasticscm.com";
    description = "SCM by Unity for game development";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ musjj ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

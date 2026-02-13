{
  dpkg,
  fetchurl,
  lib,
  makeWrapper,
  stdenvNoCC,
  writeShellApplication,
  common-updater-scripts,
  curl,
  jc,
  jq,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plasticscm-client-core-unwrapped";
  version = "11.0.16.9925";

  src = fetchurl {
    url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-core_${finalAttrs.version}_amd64.deb";
    hash = "sha256-cysJFw10nTNh+WzDCFFN2DLVwhbeSnOJ5JGMNQEqd60=";
    nativeBuildInputs = [ dpkg ];
    downloadToTemp = true;
    recursiveHash = true;
    postFetch = ''
      mkdir -p $out
      dpkg-deb --fsys-tarfile $downloadedFile | tar --extract --directory=$out
      rm -rf $out/usr/share/doc
    '';
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt usr/{share,bin} $out

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-plasticscm-client-core-unwrapped";
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
        jq -r '[.[] | select(.package == "plasticscm-client-core")] | sort_by(.version) | last | .version')"

      update-source-version --ignore-same-hash plasticscm-client-core-unwrapped "$version"
    '';
  });

  meta = {
    homepage = "https://www.plasticscm.com";
    description = "SCM by Unity for game development";
    platforms = [ "x86_64-linux" ];
    mainProgram = "cm";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ musjj ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

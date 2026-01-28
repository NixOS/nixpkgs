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
  pname = "plasticscm-client-gui-unwrapped";
  version = "11.0.16.9890";

  src = fetchurl {
    url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-gui_${finalAttrs.version}_amd64.deb";
    hash = "sha256-zaknvpMzMevz/xvacd5QUacG8Kw8RPss5K23+M4M2bk=";
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
    cp -r opt usr/{share,bin} $out

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-plasticscm-client-gui-unwrapped";
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
        jq -r '[.[] | select(.package == "plasticscm-client-gui")] | sort_by(.version) | last | .version')"

      update-source-version --ignore-same-hash plasticscm-client-gui-unwrapped "$version"
    '';
  });

  meta = {
    homepage = "https://www.plasticscm.com";
    description = "SCM by Unity for game development";
    platforms = [ "x86_64-linux" ];
    mainProgram = "plasticgui";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ musjj ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

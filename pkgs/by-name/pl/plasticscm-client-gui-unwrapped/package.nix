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
  version = "11.0.16.9791";

  src = fetchurl {
    url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-gui_${finalAttrs.version}_amd64.deb";
    hash = "sha256-sSabW3j9h9uNQSwWKvAH+3D9lRWvMRYcuITDonD7Inw=";
  };

  nativeBuildInputs = [
    dpkg
  ];

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
      jc
      jq
    ];
    text = ''
      eval "$(curl -sSL https://www.plasticscm.com/plasticrepo/stable/debian/Packages |
        jc --pkg-index-deb |
        jq -r '[.[] | select(.package == "plasticscm-client-gui")] | sort_by(.version) | last | @sh "version=\(.version) hash=\(.sha256)"')"
      # shellcheck disable=SC2154
      update-source-version plasticscm-client-gui-unwrapped "$version" "sha256-$(xxd -r -p <<<"$hash" | base64)"
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

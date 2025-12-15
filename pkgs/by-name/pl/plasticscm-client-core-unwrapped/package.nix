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
  version = "11.0.16.9791";

  src = fetchurl {
    url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-core_${finalAttrs.version}_amd64.deb";
    hash = "sha256-NuMY75JnnWVRKBSh/1XYipqc0m+O0vt7lJMVkQyTaNA=";
  };

  nativeBuildInputs = [
    dpkg
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
      jc
      jq
    ];
    text = ''
      eval "$(curl -sSL https://www.plasticscm.com/plasticrepo/stable/debian/Packages |
        jc --pkg-index-deb |
        jq -r '[.[] | select(.package == "plasticscm-client-core")] | sort_by(.version) | last | @sh "version=\(.version) hash=\(.sha256)"')"
      # shellcheck disable=SC2154
      update-source-version plasticscm-client-core-unwrapped "$version" "sha256-$(xxd -r -p <<<"$hash" | base64)"
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

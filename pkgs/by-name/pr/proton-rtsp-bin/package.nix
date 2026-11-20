{
  lib,
  mkProtonBinDerivation,
  proton-bin-update-script,
  fetchzip,
}:
mkProtonBinDerivation (finalAttrs: {
  steamDisplayName = "Proton-RTSP";

  pname = "proton-rtsp-bin";
  version = "11.0-20260609-4";

  variants = {
    "x86_64-linux" = {
      toolName = "proton-rtsp-${finalAttrs.version}";
      src = fetchzip {
        url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/proton-rtsp-${finalAttrs.version}/proton-rtsp-${finalAttrs.version}.tar.gz";
        hash = "sha256-ENLAPkz6PhqBpGibwjnWJE8NEnUnmoM81IuPQB9Ufoc=";
      };
    };
  };

  # Upstream tags releases as `proton-rtsp-<version>`; older `GE-Proton*-rtsp*` tags are ignored
  passthru.updateScript = proton-bin-update-script {
    latestVersionCommand = ''
      curl -fsSL "https://api.github.com/repos/SpookySkeletons/proton-ge-rtsp/releases" \
        | jq -er 'map(select(.prerelease == false and (.tag_name | startswith("proton-rtsp-"))))
          | .[0].tag_name | ltrimstr("proton-rtsp-")'
    '';
  };

  meta = {
    description = ''
      Compatibility tool for Steam Play based on Wine and additional components, with patches for VR social games.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/SpookySkeletons/proton-ge-rtsp";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      mistyttm
    ];
  };
})

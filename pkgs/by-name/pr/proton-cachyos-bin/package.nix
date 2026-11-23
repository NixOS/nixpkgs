{
  lib,
  mkProtonBinDerivation,
  proton-bin-update-script,
  fetchzip,
}:
mkProtonBinDerivation (finalAttrs: {
  steamDisplayName = "Proton-CachyOS";

  pname = "proton-cachyos-bin";
  version = "11.0-20261015";

  variants = {
    "x86_64-linux" = {
      toolName = "proton-cachyos-${finalAttrs.version}-slr-x86_64";
      src = fetchzip {
        url = "https://github.com/CachyOS/proton-cachyos/releases/download/cachyos-${finalAttrs.version}-slr/proton-cachyos-${finalAttrs.version}-slr-x86_64.tar.xz";
        hash = "sha256-Vb1AvDQLIpgxr3ABPMstM3DFRN1tfUD+6OnhQirMnAQ=";
      };
    };
    "aarch64-linux" = {
      toolName = "proton-cachyos-${finalAttrs.version}-slr-arm64";
      src = fetchzip {
        url = "https://github.com/CachyOS/proton-cachyos/releases/download/cachyos-${finalAttrs.version}-slr/proton-cachyos-${finalAttrs.version}-slr-arm64.tar.xz";
        hash = "sha256-xV683d43wjkDyERXknf4yDzQbWVlD3w+Wo4H6AxeIis=";
      };
    };
  };

  # Upstream tags releases as `cachyos-<version>-slr`
  passthru.updateScript = proton-bin-update-script {
    latestVersionCommand = ''
      curl -fsSL "https://api.github.com/repos/CachyOS/proton-cachyos/releases" \
        | jq -er 'map(select(.prerelease == false and (.tag_name | startswith("cachyos-") and endswith("-slr"))))
          | .[0].tag_name | ltrimstr("cachyos-") | rtrimstr("-slr")'
    '';
  };

  meta = {
    description = ''
      Compatibility tool for Steam Play based on Wine and additional components.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/CachyOS/proton-cachyos";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      mistyttm
    ];
  };
})

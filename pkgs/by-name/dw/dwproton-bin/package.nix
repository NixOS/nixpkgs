{
  lib,
  mkProtonBinDerivation,
  proton-bin-update-script,
  fetchzip,
}:
mkProtonBinDerivation (finalAttrs: {
  steamDisplayName = "dwproton";

  pname = "dwproton-bin";
  version = "dwproton-11.0-16";

  variants = {
    "x86_64-linux" = {
      toolName = "${finalAttrs.version}-x86_64";
      src = fetchzip {
        url = "https://dawn.wine/dawn-winery/dwproton/releases/download/${finalAttrs.version}/${finalAttrs.version}-x86_64.tar.xz";
        hash = "sha256-fNAT/PRoWE5WcjGmoZYjPXx+wF0rlKuUXWQk0+P7s7U=";
      };
    };
  };

  passthru.updateScript = proton-bin-update-script {
    latestVersionCommand = ''
      curl -fsSL "https://dawn.wine/api/v1/repos/dawn-winery/dwproton/releases?pre-release=false&limit=1" \
        | jq -er '.[0].tag_name'
    '';
  };

  meta = {
    description = ''
      Dawn Winery's custom Proton fork with fixes for various games.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://dawn.wine/dawn-winery/dwproton";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      Renna42
    ];
  };
})

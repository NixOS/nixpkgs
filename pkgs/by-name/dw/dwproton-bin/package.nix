{
  lib,
  fetchzip,
  writeScript,
  proton-ge-bin,

  steamDisplayName ? "dwproton",
}:
proton-ge-bin.overrideAttrs (
  finalAttrs: _: {
    inherit steamDisplayName;

    pname = "dwproton-bin";
    version = "dwproton-10.0-23";

    src = fetchzip {
      url = "https://dawn.wine/dawn-winery/dwproton/releases/download/${finalAttrs.version}/${finalAttrs.version}-x86_64.tar.xz";
      hash = "sha256-XqXXxsTekvTUNsykpWu4vbZ4Mi+2tMR57zngaOt+3gQ=";
    };

    passthru.updateScript = writeScript "update-dwproton" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts
      version=$(curl -sL "https://dawn.wine/api/v1/repos/dawn-winery/dwproton/tags?page=1\&limit=1" | jq -r .[0].name)
      update-source-version dwproton-bin "$version"
    '';

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
      platforms = [ "x86_64-linux" ];
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  }
)

{
  lib,
  fetchzip,
  writeScript,
  proton-ge-bin,

  steamDisplayName ? "Proton CachyOS slr",
}:
proton-ge-bin.overrideAttrs (
  finalAttrs: _: {
    strictDeps = true;
    __structuredAttrs = true;

    inherit steamDisplayName;

    pname = "proton-cachyos-slr-bin";
    version = "cachyos-11.0-20260602-slr";

    src = fetchzip {
      url = "https://github.com/CachyOS/proton-cachyos/releases/download/${finalAttrs.version}/proton-${finalAttrs.version}-x86_64.tar.xz";
      hash = "sha256-m/B+WBVJZBpLUvzZZwJ4hGfjbzmohP7TBhfVt5bCzNQ=";
    };

    preFixup = ''
      substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
        --replace-fail "proton-${finalAttrs.version}-x86_64" "${steamDisplayName}"
    '';

    passthru.updateScript = writeScript "update-proton-cachyos-slr" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts
      repo="https://api.github.com/repos/CachyOS/proton-cachyos/releases/latest"
      version="$(curl -sL "$repo" | jq '.tag_name' --raw-output)"
      update-source-version proton-cachyos-slr-bin "$version"
    '';

    meta = {
      description = ''
        Compatibility tool for Steam Play based on Wine and additional components.
        This version is build against the Steam Linux Runtime (SLR).

        (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
      '';
      homepage = "https://github.com/CachyOS/proton-cachyos";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [
        Karrfy
      ];
      platforms = [ "x86_64-linux" ];
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  }
)

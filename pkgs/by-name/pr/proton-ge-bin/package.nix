{
  lib,
  mkProtonBinDerivation,
  proton-bin-update-script,
  fetchzip,
  steamDisplayName ? null,
}:
assert
  steamDisplayName == null
  || throw "proton-ge-bin: The `steamDisplayName` interface has been changed to an attribute, which is overridable using `overrideAttrs`.";

mkProtonBinDerivation (finalAttrs: {
  # Can be overridden to alter the display name in steam
  # This could be useful if multiple versions should be installed together
  steamDisplayName = "GE-Proton";

  pname = "proton-ge-bin";
  version = "GE-Proton11-12";

  variants = {
    "x86_64-linux" = {
      toolName = "${finalAttrs.version}-x86_64";
      src = fetchzip {
        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${finalAttrs.version}/${finalAttrs.version}-x86_64.tar.gz";
        hash = "sha256-i20g9lDz7bR0SXWmvHZHztN4m8AHkcD0/OVGSC4ZzI8=";
      };
    };
    "aarch64-linux" = {
      toolName = "${finalAttrs.version}-aarch64";
      src = fetchzip {
        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${finalAttrs.version}/${finalAttrs.version}-aarch64.tar.gz";
        hash = "sha256-0+ChUSgJa1IUl4yUIYAxP6hbY1oY48zzJYZkAcQZ/0Q=";
      };
    };
  };

  /*
    We use the created releases, and not the tags, for the update script as nix-update loads releases.atom
    that contains both. Sometimes upstream pushes the tags but the GitHub releases don't get created due to
    CI errors. Last time this happened was on 8-33, where a tag was created but no releases were created.
    As of 2024-03-13, there have been no announcements indicating that the CI has been fixed, and thus
    we avoid nix-update-script and use our own update script instead.
    See: <https://github.com/NixOS/nixpkgs/pull/294532#issuecomment-1987359650>
  */
  passthru.updateScript = proton-bin-update-script {
    latestVersionCommand = ''
      curl -fsSL "https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases" \
        | jq -er 'map(select(.prerelease == false)) | .[0].tag_name'
    '';
  };

  meta = {
    description = ''
      Compatibility tool for Steam Play based on Wine and additional components.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/GloriousEggroll/proton-ge-custom";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      Gliczy
      NotAShelf
      Scrumplex
      shawn8901
    ];
  };
})

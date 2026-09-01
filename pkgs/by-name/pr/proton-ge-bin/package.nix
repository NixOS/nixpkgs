{
  lib,
  stdenvNoCC,
  fetchzip,
  writeScript,
  steamDisplayName ? null,
}:
assert
  steamDisplayName == null
  || throw "proton-ge-bin: The `steamDisplayName` interface has been changed to an attribute, which is overridable using `overrideAttrs`.";

stdenvNoCC.mkDerivation (finalAttrs: {
  # Can be overridden to alter the display name in steam
  # This could be useful if multiple versions should be installed together
  steamDisplayName = "GE-Proton";

  pname = "proton-ge-bin";
  version = "GE-Proton11-5";

  inherit (finalAttrs.passthru.variants.${stdenvNoCC.hostPlatform.system}) src toolName;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  outputs = [
    "out"
    "steamcompattool"
  ];

  installPhase = ''
    runHook preInstall

    # Make it impossible to add to an environment. You should use the appropriate NixOS option.
    # Also leave some breadcrumbs in the file.
    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool

    runHook postInstall
  '';

  preFixup = ''
    substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
      --replace-fail "$toolName" "$steamDisplayName"
  '';

  passthru = {
    variants = {
      "x86_64-linux" = {
        toolName = "${finalAttrs.version}-x86_64";
        src = fetchzip {
          url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${finalAttrs.version}/${finalAttrs.version}-x86_64.tar.gz";
          hash = "sha256-Sbyi5zXMhPIKSotvL5LEZ2dbDoLpXRcCyuY9TsnBnus=";
        };
      };
      "aarch64-linux" = {
        toolName = "${finalAttrs.version}-aarch64";
        src = fetchzip {
          url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${finalAttrs.version}/${finalAttrs.version}-aarch64.tar.gz";
          hash = "sha256-fS4N2ip8IvhMfrJsfHnrq+zA/41qJd6kbLQ0+5lZ5uE=";
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
    updateScript = writeScript "update-proton-ge" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts
      repo="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases"
      version="$(curl -sL "$repo" | jq 'map(select(.prerelease == false)) | .[0].tag_name' --raw-output)"
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version proton-ge-bin "$version" --ignore-same-version --source-key="variants.$platform.src"
      done
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
    platforms = builtins.attrNames finalAttrs.passthru.variants;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})

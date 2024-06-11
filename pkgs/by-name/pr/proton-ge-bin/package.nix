{ lib
, stdenvNoCC
, fetchzip
, writeScript
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-ge-bin";
  version = "GE-Proton9-7";

  src = fetchzip {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${finalAttrs.version}/${finalAttrs.version}.tar.gz";
    hash = "sha256-/FXdyPuCe6rD5HoMOHPVlwRXu3DMJ3lEOnRloYZMA8s=";
  };

  outputs = [ "out" "steamcompattool" ];

  buildCommand = ''
    runHook preBuild

    # Make it impossible to add to an environment. You should use the appropriate NixOS option.
    # Also leave some breadcrumbs in the file.
    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    ln -s $src $steamcompattool

    runHook postBuild
  '';

  /*
    We use the created releases, and not the tags, for the update script as nix-update loads releases.atom
    that contains both. Sometimes upstream pushes the tags but the Github releases don't get created due to
    CI errors. Last time this happened was on 8-33, where a tag was created but no releases were created.
    As of 2024-03-13, there have been no announcements indicating that the CI has been fixed, and thus
    we avoid nix-update-script and use our own update script instead.
    See: <https://github.com/NixOS/nixpkgs/pull/294532#issuecomment-1987359650>
  */
  passthru.updateScript = writeScript "update-proton-ge" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    repo="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases"
    version="$(curl -sL "$repo" | jq 'map(select(.prerelease == false)) | .[0].tag_name' --raw-output)"
    update-source-version proton-ge-bin "$version"
  '';

  meta = {
    description = ''
      Compatibility tool for Steam Play based on Wine and additional components.

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/GloriousEggroll/proton-ge-custom";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ NotAShelf shawn8901 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})

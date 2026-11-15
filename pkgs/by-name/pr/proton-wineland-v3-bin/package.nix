{
  lib,
  fetchzip,
  mkProtonBinDerivation,
  proton-bin-update-script,
}:

mkProtonBinDerivation (finalAttrs: {
  pname = "proton-wineland-v3-bin";
  version = "11.0-20261114";

  steamDisplayName = "Proton-Wineland-v3";

  variants = {
    x86_64-linux = {
      src = fetchzip {
        url = "https://github.com/nanomatters/proton-salkim/releases/download/wineland-${finalAttrs.version}/proton-wineland-${finalAttrs.version}-x86_64_v3.tar.xz";
        hash = "sha256-Z53UQjQBDQy0h5MCGD5YczBN9axlUR0TWm/bavnHx0o=";
      };

      toolName = "proton-wineland-${finalAttrs.version}-x86_64_v3";
    };
  };

  passthru.updateScript = proton-bin-update-script {
    latestVersionCommand = ''
      curl -fsSL "https://api.github.com/repos/nanomatters/proton-salkim/releases" \
        | jq -er 'map(select(.prerelease == false and (.tag_name | test("^wineland-[0-9]")))) | .[0].tag_name | ltrimstr("wineland-")'
    '';
  };

  meta = {
    description = "Proton distribution with native Wayland support, built for x86-64-v3 processors";
    longDescription = ''
      Proton Wineland, part of the Salkim project, is a fork of Proton-CachyOS.
      This build requires an x86-64-v3 processor, which supports AVX2.

      This is intended for use in the `programs.steam.extraCompatPackages` option only.
    '';
    homepage = "https://github.com/nanomatters/proton-salkim";
    changelog = "https://github.com/nanomatters/proton-salkim/releases/tag/wineland-${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ keenanweaver ];
  };
})

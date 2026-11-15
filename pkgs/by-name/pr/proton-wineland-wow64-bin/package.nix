{
  lib,
  fetchzip,
  mkProtonBinDerivation,
  proton-bin-update-script,
}:

mkProtonBinDerivation (finalAttrs: {
  pname = "proton-wineland-wow64-bin";
  version = "11.0-20261114";

  steamDisplayName = "Proton-Wineland-wow64";

  variants = {
    x86_64-linux = {
      src = fetchzip {
        url = "https://github.com/nanomatters/proton-salkim/releases/download/wineland-${finalAttrs.version}/proton-wineland-${finalAttrs.version}-x86_64_wow64.tar.xz";
        hash = "sha256-YtszIM9WWpmxlCvnMi1QyL9rct5wdqGwGvFTH3/Zwio=";
      };

      toolName = "proton-wineland-${finalAttrs.version}-x86_64_wow64";
    };
  };

  passthru.updateScript = proton-bin-update-script {
    latestVersionCommand = ''
      curl -fsSL "https://api.github.com/repos/nanomatters/proton-salkim/releases" \
        | jq -er 'map(select(.prerelease == false and (.tag_name | test("^wineland-[0-9]")))) | .[0].tag_name | ltrimstr("wineland-")'
    '';
  };

  meta = {
    description = "Proton distribution with native Wayland support, built with Wine's WoW64 mode";
    longDescription = ''
      Proton Wineland, part of the Salkim project, is a fork of Proton-CachyOS.
      This build runs 32-bit Windows programs through Wine's WoW64 mode instead of 32-bit Linux libraries.

      This is intended for use in the `programs.steam.extraCompatPackages` option only.
    '';
    homepage = "https://github.com/nanomatters/proton-salkim";
    changelog = "https://github.com/nanomatters/proton-salkim/releases/tag/wineland-${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ keenanweaver ];
  };
})

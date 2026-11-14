{
  lib,
  fetchzip,
  mkProtonBinDerivation,
  proton-bin-update-script,
}:

mkProtonBinDerivation (finalAttrs: {
  pname = "luxtorpeda-bin";
  version = "77.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  steamDisplayName = "Luxtorpeda";

  variants = {
    x86_64-linux = {
      src = fetchzip {
        url = "https://codeberg.org/luxtorpeda/luxtorpeda/releases/download/v${finalAttrs.version}/luxtorpeda-v${finalAttrs.version}.tar.xz";
        hash = "sha256-9UR+VRDvyUIBHr9j0+pdi3qtK6M878QsaDhwb2oe7ow=";
      };
      toolName = "Luxtorpeda";
    };
  };

  passthru.updateScript = proton-bin-update-script {
    latestVersionCommand = ''
      curl -fsSL "https://codeberg.org/api/v1/repos/luxtorpeda/luxtorpeda/releases?pre-release=false&limit=1" \
        | jq -er '.[0].tag_name | ltrimstr("v")'
    '';
  };

  meta = {
    description = "Steam Play compatibility tool to run games using native Linux engines";
    homepage = "https://luxtorpeda.org";
    changelog = "https://codeberg.org/luxtorpeda/luxtorpeda/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
  };
})

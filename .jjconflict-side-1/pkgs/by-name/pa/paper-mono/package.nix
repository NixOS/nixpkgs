{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "paper-mono";
  version = "0.320";
  __structuredAttrs = true;

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url = "https://github.com/paper-design/paper-mono/releases/download/v${finalAttrs.version}/paper-mono-v${finalAttrs.version}.zip";
    hash = "sha256-IF5CxmXgkf9xNjOID3BgBInRAOoyOrpPa0FhrkSAqe8=";
  };

  strictDeps = true;
  nativeBuildInputs = [ installFonts ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Beautiful monospace font for design and code by Paper";
    homepage = "https://github.com/paper-design/paper-mono";
    changelog = "https://github.com/paper-design/paper-mono/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "paper-mono";
  version = "1.000";
  __structuredAttrs = true;

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url = "https://github.com/paper-design/paper-mono/releases/download/v${finalAttrs.version}/paper-mono-v${finalAttrs.version}.zip";
    hash = "sha256-h5yTJS+Oln2r4HcuHu3gjrw41udw/Uj/rmV/niPfaEg=";
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

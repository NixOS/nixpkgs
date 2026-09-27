{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  installFonts,
  # Variant selection, mirroring the upstream release matrix
  # JetBrainsMapleMono-[NF/XX]-[NR/XX]-[NL/XX]-[HT/XX].zip
  nerdFont ? false, # bundle Nerd Font icon glyphs
  cnNarrow ? false, # narrower CJK glyphs; gives up 2:1 CJK/Latin alignment
  ligatures ? true, # false selects the no-ligature build
  hinted ? false, # TrueType hinting for low-DPI rendering
}:

let
  flag = enabled: code: if enabled then code else "XX";
  variant = lib.concatStringsSep "-" [
    (flag nerdFont "NF")
    (flag cnNarrow "NR")
    (flag (!ligatures) "NL")
    (flag hinted "HT")
  ];
  hashes = lib.importJSON ./hashes.json;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jetbrains-maple-mono";
  version = "1.2304.79";

  strictDeps = true;
  __structuredAttrs = true;

  # Upstream regenerates the release assets in place when its fusion pipeline
  # changes, so the hashes can go stale without a new tag. The update script
  # refreshes hashes.json even when the version is unchanged.
  src = fetchurl {
    url = "https://github.com/SpaceTimee/Fusion-JetBrainsMapleMono/releases/download/${finalAttrs.version}/JetBrainsMapleMono-${variant}.zip";
    hash = hashes.${variant};
  };

  # The archive has no top-level directory.
  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    installFonts
  ];

  passthru = {
    inherit variant;
    updateScript = ./update.sh;
  };

  meta = {
    description = "JetBrains Mono with CJK glyphs from Maple Mono (${variant})";
    longDescription = ''
      A monospace font that fuses JetBrains Mono with the Chinese and Japanese
      glyphs of Maple Mono, keeping 2:1 CJK/Latin width alignment. Nerd Font
      glyphs, narrow CJK spacing, ligature-free and hinted builds are selected
      through the `nerdFont`, `cnNarrow`, `ligatures` and `hinted` arguments.
    '';
    homepage = "https://github.com/SpaceTimee/Fusion-JetBrainsMapleMono";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ konakonai ];
  };
})

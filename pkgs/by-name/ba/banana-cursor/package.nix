{
  clickgen,
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "banana-cursor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "banana-cursor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PI7381xf/GctQTnfcE0W3M3z2kqbX4VexMf17C61hT8=";
  };

  nativeBuildInputs = [
    clickgen
  ];

  buildPhase = ''
    runHook preBuild

    ctgen build.toml --platforms x11 --bitmaps-dir bitmaps/Banana --out-dir $out/share/icons

    runHook postBuild
  '';

  meta = {
    description = "Banana Cursor";
    homepage = "https://github.com/ful1e5/banana-cursor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      getpsyched
      yrd
    ];
    platforms = lib.platforms.linux;
  };
})

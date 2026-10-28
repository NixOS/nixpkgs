{
  deno,
  lib,
  makeWrapper,
  src,
  stdenvNoCC,
  version,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit src version;
  pname = "flatpak-deno-generator";

  sourceRoot = "${finalAttrs.src.name}/deno";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib/flatpak-deno-generator
    makeWrapper ${lib.getExe deno} $out/bin/flatpak-deno-generator \
      --add-flag -RN \
      --add-flag -W=. \
      --add-flag $out/lib/flatpak-deno-generator/src/main.ts
    cp -a * $out/lib/flatpak-deno-generator
    runHook postInstall
  '';

  installCheckPhase = ''
    $out/bin/flatpak-deno-generator --help
  '';
})

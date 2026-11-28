{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "galmuri";
  version = "2.40.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/quiple/galmuri/releases/download/v${finalAttrs.version}/Galmuri-v${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-RNM+YeGDZJn4gyYY7KMmQUoUJRf+FCttqgqiwlt8e1U=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 *.ttf -t $out/share/fonts/truetype
    install -Dm444 *.bdf -t $out/share/fonts/misc
    install -Dm444 *.woff2 -t $out/share/fonts/woff2
    install -Dm444 LICENSE.txt -t $out/share/doc/galmuri

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pixel fonts inspired by the Nintendo DS";
    homepage = "https://galmuri.quiple.dev/";
    changelog = "https://github.com/quiple/galmuri/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers._7nzzbzn5dt-art ];
    platforms = lib.platforms.all;
  };
})

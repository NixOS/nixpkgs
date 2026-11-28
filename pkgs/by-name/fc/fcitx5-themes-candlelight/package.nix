{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  jdupes,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-themes-candlelight";
  version = "1.0.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "thep0y";
    repo = "fcitx5-themes-candlelight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Aca8JZxhdNjr/g2oRDWHsnj8mm+jvlEaxYRqCR4sU60=";
  };

  nativeBuildInputs = [ jdupes ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes
    cp -r autumn winter spring summer transparent-green green macOS-* $out/share/fcitx5/themes/
    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalist skin for fcitx5";
    homepage = "https://github.com/thep0y/fcitx5-themes-candlelight";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Holiu618 ];
    platforms = lib.platforms.all;
  };
})

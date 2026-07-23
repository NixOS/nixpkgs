{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plasmavantage";
  version = "0.30";
  src = fetchFromGitLab {
    owner = "Scias";
    repo = "plasmavantage";
    tag = finalAttrs.version;
    hash = "sha256-++WewCzTWGrMTXhBQQ339W/bDgKO040xeBNhozljsko=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids
    cp -r $src/package $out/share/plasma/plasmoids/com.gitlab.scias.plasmavantage

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Plasmoid for controlling certain features of Lenovo laptops";
    homepage = "https://gitlab.com/Scias/plasmavantage";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchurl,
  gtk-engine-murrine,
}:

let
  themeName = "Ant-Nebula";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ant-nebula-theme";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/EliverLara/${themeName}/releases/download/v${finalAttrs.version}/${themeName}.tar";
    hash = "sha256-f8lkJrUN8bBuqdMz+7IGJqr2wN5bvHpImfJVe07h7/Y=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/${themeName}
    cp -a * $out/share/themes/${themeName}
    rm -r $out/share/themes/${themeName}/{Art,LICENSE,README.md,gtk-2.0/render-assets.sh}
    runHook postInstall
  '';

  meta = {
    description = "Nebula variant of the Ant theme";
    homepage = "https://github.com/EliverLara/${themeName}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ alexarice ];
  };
})

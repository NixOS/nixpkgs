{
  lib,
  stdenv,
  fetchurl,
  gtk-engine-murrine,
}:

let
  themeName = "Ant";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ant-theme";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/EliverLara/${themeName}/releases/download/v${finalAttrs.version}/${themeName}.tar";
    hash = "sha256-vx2iwnJIB+JhFaEwZsYTQ0VXV3MCI4AbWexzb9Iu6eQ=";
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
    description = "Flat and light theme with a modern look";
    homepage = "https://github.com/EliverLara/${themeName}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ alexarice ];
  };
})

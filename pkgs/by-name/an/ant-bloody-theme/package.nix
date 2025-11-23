{
  lib,
  stdenv,
  fetchurl,
  gtk-engine-murrine,
}:

let
  themeName = "Ant-Bloody";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ant-bloody-theme";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/EliverLara/${themeName}/releases/download/v${finalAttrs.version}/${themeName}.tar";
    hash = "sha256-Gv1ibTN+RkHQ0QjUEgvanVOm1j2G5w1PkLjKXycoP2c=";
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
    description = "Bloody variant of the Ant theme";
    homepage = "https://github.com/EliverLara/${themeName}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ alexarice ];
  };
})

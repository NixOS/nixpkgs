{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  inkcut,
  callPackage,
  texliveBasic,
}:

{
  applytransforms = callPackage ./extensions/applytransforms { };

  hexmap = stdenv.mkDerivation (finalAttrs: {
    pname = "hexmap";
    version = "3.0pre2";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "lifelike";
      repo = "hexmapextension";
      tag = finalAttrs.version;
      hash = "sha256-pSPAupp3xLlbODE2BGu1Xiiiu1Y6D4gG4HhZwccAZ2E=";
    };

    preferLocalBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/inkscape/extensions"
      cp -p *.inx *.py "$out/share/inkscape/extensions/"
      find "$out/share/inkscape/extensions/" -name "*.py" -exec chmod +x {} \;

      runHook postInstall
    '';

    meta = {
      description = "This is an extension for creating hex grids in Inkscape. It can also be used to make brick patterns of staggered rectangles";
      homepage = "https://github.com/lifelike/hexmapextension";
      license = lib.licenses.gpl2Plus;
      maintainers = [ lib.maintainers.raboof ];
      platforms = lib.platforms.all;
    };
  });
  inkcut = (
    runCommand "inkcut-inkscape-plugin" { } ''
      mkdir -p $out/share/inkscape/extensions
      cp ${inkcut}/share/inkscape/extensions/* $out/share/inkscape/extensions
    ''
  );
  inkstitch = callPackage ./extensions/inkstitch { };
  silhouette = callPackage ./extensions/silhouette { };
  textext = callPackage ./extensions/textext {
    pdflatex = texliveBasic;
    lualatex = texliveBasic;
  };
}

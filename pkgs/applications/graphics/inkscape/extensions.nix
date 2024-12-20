{ lib, stdenv
, fetchFromGitHub
, runCommand
, inkcut
, callPackage
, texlive
}:

{
  applytransforms = callPackage ./extensions/applytransforms { };

  hexmap = stdenv.mkDerivation {
    pname = "hexmap";
    version = "unstable-2023-01-26";

    src = fetchFromGitHub {
      owner = "lifelike";
      repo = "hexmapextension";
      rev = "241c9512d0113e8193b7cf06b69ef2c4730b0295";
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

    meta = with lib; {
      description = "This is an extension for creating hex grids in Inkscape. It can also be used to make brick patterns of staggered rectangles";
      homepage = "https://github.com/lifelike/hexmapextension";
      license = licenses.gpl2Plus;
      maintainers = [ maintainers.raboof ];
      platforms = platforms.all;
    };
  };
  inkcut = (runCommand "inkcut-inkscape-plugin" {} ''
    mkdir -p $out/share/inkscape/extensions
    cp ${inkcut}/share/inkscape/extensions/* $out/share/inkscape/extensions
  '');
  inkstitch = callPackage ./extensions/inkstitch { };
  silhouette = callPackage ./extensions/silhouette { };
  textext = callPackage ./extensions/textext {
    pdflatex = texlive.combined.scheme-basic;
    lualatex = texlive.combined.scheme-basic;
  };
}

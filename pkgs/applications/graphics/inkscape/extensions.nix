{ lib, stdenv
, fetchFromGitHub
, runCommand
, inkcut
, callPackage
}:

{
  applytransforms = callPackage ./extensions/applytransforms { };

  hexmap = stdenv.mkDerivation {
    pname = "hexmap";
    version = "unstable-2020-06-06";

    src = fetchFromGitHub {
      owner = "lifelike";
      repo = "hexmapextension";
      rev = "11401e23889318bdefb72df6980393050299d8cc";
      sha256 = "1a4jhva624mbljj2k43wzi6hrxacjz4626jfk9y2fg4r4sga22mm";
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
}

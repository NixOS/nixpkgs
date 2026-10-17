{
  lib,
  stdenv,
  fetchurl,
  fontforge,
  installFonts,
}:

stdenv.mkDerivation {
  pname = "linux-libertine";
  version = "5.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/linuxlibertine/5.3.0/LinLibertineSRC_5.3.0_2012_07_02.tgz";
    hash = "sha256-G+xDYKJvHPMzwnktkg9cpNTv9E9d5QFgDjReuKH57HQ=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    fontforge
    installFonts
  ];

  dontConfigure = true;
  dontInstallFonts = true;

  buildPhase = ''
    runHook preBuild
    for i in *.sfd; do
      fontforge -lang=ff -c \
        'Open($1);
        ScaleToEm(1000);
        Reencode("unicode");
        Generate($1:r + ".ttf");
        Generate($1:r + ".otf");
        Reencode("TeX-Base-Encoding");
        Generate($1:r + ".afm");
        Generate($1:r + ".pfm");
        Generate($1:r + ".pfb");
        Generate($1:r + ".map");
        Generate($1:r + ".enc");
        ' $i;
    done
    runHook postBuild
  '';

  postInstall = ''
    installFont otf $out/share/fonts/opentype/public
    installFont ttf $out/share/fonts/truetype/public
    installFont pfb $out/share/fonts/type1/public
    installFont enc $out/share/texmf/fonts/enc
    installFont map $out/share/texmf/fonts/map
  '';

  meta = {
    description = "Linux Libertine Fonts";
    homepage = "http://linuxlibertine.sf.net";
    maintainers = with lib.maintainers; [ erdnaxe ];
    license = lib.licenses.ofl;
  };
}

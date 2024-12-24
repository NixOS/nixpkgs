{
  lib,
  stdenv,
  fetchurl,
  cabextract,
}:

let
  fonts = [
    {
      name = "andale";
      hash = "sha256-BST+QpUa3Dp+uHDjLwkgMTxx8XDIWbX3cNgrTuER6XA=";
    }
    {
      name = "arial";
      hash = "sha256-hSl6TRRunIesb3SCJzS97l9LKnItfqpYS38sv3b0ePY=";
    }
    {
      name = "arialb";
      hash = "sha256-pCXw/7ahpe3luXntYXf09PT972rnwwKnt3IO8zL+wKg=";
    }
    {
      name = "comic";
      hash = "sha256-nG3z/u/eJtTkHUpP5dsqifkSOncllNf1mv0GJiXNIE4=";
    }
    {
      name = "courie";
      hash = "sha256-u1EdhhZV3eh5rlUuuGsTTW+uZ8tYUC5v9z7F2RUfM4Q=";
    }
    {
      name = "georgi";
      hash = "sha256-LCx9zaZgbqXPCJGPt80/M1np6EM43GkAE/IM1C6TAwE=";
    }
    {
      name = "impact";
      hash = "sha256-YGHvO3QB2WQvXf218rN2qhRmP2J15gpRIHrU+s8vzPs=";
    }
    {
      name = "times";
      hash = "sha256-21ZZXsbvXT3lwkmU8AHwOyoT43zuJ7wlxY9vQ+j4B6s=";
    }
    {
      name = "trebuc";
      hash = "sha256-WmkNm7hRC+G4tP5J8fIxllH+UbvlR3Xd3djvC9B/2sk=";
    }
    {
      name = "webdin";
      hash = "sha256-ZFlbWrwQgPuoYQxcNPq1hjQI6Aaq/oRlPKhXW+0X11o=";
    }
    {
      name = "verdan";
      hash = "sha256-wcthJV42MWZ5TkdmTi8hr446JstjRuuNKuL6hd1arZY=";
    }
    {
      name = "wd97vwr";
      hash = "sha256-9hEmptF7LRJqfzGxQlBNzkk095icVfHBPGR3s/6As9I=";
    }
  ];

  eula = fetchurl {
    url = "https://corefonts.sourceforge.net/eula.htm";
    hash = "sha256-LOgNEsM+dANEreP2LsFi+pAnBNDMFB9Pg+KJAahlC6s=";
  };
in
stdenv.mkDerivation {
  pname = "corefonts";
  version = "1";

  exes = map (
    { name, hash }:
    fetchurl {
      url = "mirror://sourceforge/corefonts/the%20fonts/final/${name}32.exe";
      inherit hash;
    }
  ) fonts;

  nativeBuildInputs = [ cabextract ];

  buildCommand = ''
    for i in $exes; do
      cabextract --lowercase $i
    done
    cabextract --lowercase viewer1.cab

    # rename to more standard names
    # handle broken macOS file-system
    mv andalemo.ttf  Andale_Mono.ttf
    mv ariblk.ttf    Arial_Black.ttf
    mv arial.ttf     Arial.ttf.tmp
    mv Arial.ttf.tmp Arial.ttf
    mv arialbd.ttf   Arial_Bold.ttf
    mv arialbi.ttf   Arial_Bold_Italic.ttf
    mv ariali.ttf    Arial_Italic.ttf
    mv comic.ttf     Comic_Sans_MS.ttf
    mv comicbd.ttf   Comic_Sans_MS_Bold.ttf
    mv cour.ttf      Courier_New.ttf
    mv courbd.ttf    Courier_New_Bold.ttf
    mv couri.ttf     Courier_New_Italic.ttf
    mv courbi.ttf    Courier_New_Bold_Italic.ttf
    mv georgia.ttf   Georgia.ttf.tmp
    mv Georgia.ttf.tmp   Georgia.ttf
    mv georgiab.ttf  Georgia_Bold.ttf
    mv georgiai.ttf  Georgia_Italic.ttf
    mv georgiaz.ttf  Georgia_Bold_Italic.ttf
    mv impact.ttf    Impact.ttf.tmp
    mv Impact.ttf.tmp    Impact.ttf
    mv tahoma.ttf    Tahoma.ttf.tmp
    mv Tahoma.ttf.tmp    Tahoma.ttf
    mv times.ttf     Times_New_Roman.ttf
    mv timesbd.ttf   Times_New_Roman_Bold.ttf
    mv timesbi.ttf   Times_New_Roman_Bold_Italic.ttf
    mv timesi.ttf    Times_New_Roman_Italic.ttf
    mv trebuc.ttf    Trebuchet_MS.ttf
    mv trebucbd.ttf  Trebuchet_MS_Bold.ttf
    mv trebucit.ttf  Trebuchet_MS_Italic.ttf
    mv trebucbi.ttf  Trebuchet_MS_Italic.ttf
    mv verdana.ttf   Verdana.ttf.tmp
    mv Verdana.ttf.tmp   Verdana.ttf
    mv verdanab.ttf  Verdana_Bold.ttf
    mv verdanai.ttf  Verdana_Italic.ttf
    mv verdanaz.ttf  Verdana_Bold_Italic.ttf
    mv webdings.ttf  Webdings.ttf.tmp
    mv Webdings.ttf.tmp  Webdings.ttf

    install -m444 -Dt $out/share/fonts/truetype *.ttf

    # Also put the EULA there to be on the safe side.
    cp ${eula} $out/share/fonts/truetype/eula.html

    # Set up no-op font configs to override any aliases set up by other packages.
    mkdir -p $out/etc/fonts/conf.d
    for name in Andale-Mono Arial-Black Arial Comic-Sans-MS \
                Courier-New Georgia Impact Times-New-Roman \
                Trebuchet Verdana Webdings ; do
      substitute ${./no-op.conf} $out/etc/fonts/conf.d/30-''${name,,}.conf \
        --subst-var-by fontname "''${name//-/ }"
    done
  '';

  meta = with lib; {
    homepage = "https://corefonts.sourceforge.net/";
    description = "Microsoft's TrueType core fonts for the Web";
    platforms = platforms.all;
    license = licenses.unfreeRedistributable;
    # Set a non-zero priority to allow easy overriding of the
    # fontconfig configuration files.
    priority = 5;
  };
}

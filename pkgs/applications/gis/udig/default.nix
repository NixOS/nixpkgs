{ stdenv, lib, fetchurl, unzip, makeWrapper, jre8, libXtst, gdal }:
let
  pname = "udig";
  version = "2.0.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "http://udig.refractions.net/files/downloads/udig-${version}.linux.gtk.x86_64.zip";
      sha256 = "03hj1mdd6sq0gbpa838wkccibp3l2hvnwxxf5dyc0jk3mmd94fwa";
    };
    x86_64-darwin = fetchurl {
      url = "http://udig.refractions.net/files/downloads/udig-${version}.macosx.cocoa.x86_64.zip";
      sha256 = "16rcyp1zy3lr1hwjhzh6vwcgck52w66dm1qsc52gppy1f4i3f692";
    };
  };
  src = srcs.${stdenv.hostPlatform.system};

  meta = with lib; {
    description = "User-friendly Desktop Internet GIS";
    homepage = "http://udig.refractions.net/";
    license = with licenses; [ epl10 bsd3 ];
    maintainers = with maintainers; [ sikmir ];
    platforms = builtins.attrNames srcs;
  };

  linux = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ unzip makeWrapper ];

    installPhase = ''
      install -dm755 $out/bin $out/opt/udig
      cp -r . $out/opt/udig
      makeWrapper $out/opt/udig/udig.sh $out/bin/udig \
        --prefix PATH : ${jre8}/bin \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ libXtst gdal ])}
    '';

    postFixup = ''
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        $out/opt/udig/udig_internal
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ unzip makeWrapper ];

    postPatch = ''
      substituteInPlace configuration/config.ini \
        --replace "\$LOCALAPPDATA\$" "@user.home"
    '';

    installPhase = ''
      mkdir -p $out/Applications/udig
      cp -R . $out/Applications/udig
      wrapProgram $out/Applications/udig/udig.app/Contents/MacOS/udig_internal \
        --prefix DYLD_LIBRARY_PATH : ${lib.makeLibraryPath ([ gdal ])}
    '';
  };
in
if stdenv.isDarwin
then darwin
else linux

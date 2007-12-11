args:
let optionIncLib = name : attr : " -D${name}_INCLUDE_DIR=${__getAttr attr args}/inc"
                               + " -D${name}_LIBRARY=${__getAttr attr args}/lib "; # lib 64?
in
( args.mkDerivationByConfiguration {

    flagConfig = {
      mandatory = { 
        buildInputs = [ "gdal" "cmake" "qt" "flex" "bison" "proj" "geos" "x11" "sqlite" "gsl"]; 
        cfgOption = [ (optionIncLib "GEOS" "geos") 
                         (optionIncLib "PROJ" "proj")
                         (optionIncLib "QT_X11_X11" "qt")
                         (optionIncLib "QT_X11_Xext" "qt")
                         (optionIncLib "QT_X11_m" "glibc")
                         (optionIncLib "SQLITE3" "sqlite")

"-DQT_FONTCONFIG_LIBRARY=${args.fontconfig}/lib"
"-DQT_FREETYPE_LIBRARY=${args.freetype}/lib"
"-DQT_PNG_LIBRARY=${args.libpng}/lib"
"-DQT_X11_ICE_LIBRARY=${args.libICE}/lib"
"-DQT_X11_SM_LIBRARY=${args.libSM}/lib"
"-DQT_XCURSOR_LIBRARY=${args.libXcursor}/lib"
"-DQT_XINERAMA_LIBRARY=${args.libXinerama}/lib"
"-DQT_XRANDR_LIBRARY=${args.libXrandr}/lib"
"-DQT_XRENDER_LIBRARY=${args.libXrender}/lib"
"-DQT_ZLIB_LIBRARY=${args.zlib}/lib"
                         ];

/* advanced options - feel free to add them if you have time to
"-DPROJ_INCLUDE_DIR"
"-DPROJ_LIBRARY"
"-DQT_X11_X11_LIBRARY"
"-DQT_X11_Xext_LIBRARY"
"-DQT_X11_m_LIBRARY"
"-DSQLITE3_INCLUDE_DIR"
"-DSQLITE3_LIBRARY"
-DQT_FONTCONFIG_LIBRARY (ADVANCED)
-DQT_FREETYPE_LIBRARY (ADVANCED)
-DQT_PNG_LIBRARY (ADVANCED)
-DQT_X11_ICE_LIBRARY (ADVANCED)
-DQT_X11_SM_LIBRARY (ADVANCED)
-DQT_XCURSOR_LIBRARY (ADVANCED)
-DQT_XINERAMA_LIBRARY (ADVANCED)
-DQT_XRANDR_LIBRARY (ADVANCED)
-DQT_XRENDER_LIBRARY (ADVANCED)
-DQT_ZLIB_LIBRARY (ADVANCED)
*/
      };
    }; 

    #inherit geos proj x11 libXext;

    extraAttrs = co : {

    name = "qgis-svn";

    src = args.fetchsvn { url=https://svn.qgis.org/repos/qgis/trunk/qgis; 
                    md5="ac0560e0a2d4e6258c8639f1e9b56df3"; rev="7704"; };

    meta = { 
      description = "user friendly Open Source Geographic Information System";
      homepage = http://www.qgis.org;
      # you can choose one of the following licenses: 
      license = [ "GPL" ];
    };

    phases = "unpackPhase buildPhase installPhase";
    buildPhase = "cmake -DCMAKE_INSTALL_PREFIX=\$out ${co.configureFlags} .";

    #configurePhase="./autogen.sh --prefix=\$out --with-gdal=\$gdal/bin/gdal-config --with-qtdir=\$qt";
    # buildPhases="unpackPhase buildPhase";
  };

} ) args

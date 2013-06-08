{ config, ... }@a:

# You can set gui by exporting GRASS_GUI=..
# see http://grass.itc.it/gdp/html_grass64/g.gui.html
# defaulting to wxpython because this is used in the manual
let inherit (builtins) getAttr;
    inherit (a.composableDerivation) edf wwf;
    inherit (a.stdenv.lib) maybeAttr optionalString;

    # wrapper for wwf call
    # lib: the lib whose include and lib paths should be passed
    # {}@args: additional args being merged before passing everything to wwf
    wwfp = lib: {name, ...}@args:
      let mbEnable = maybeAttr "enable" {} args;
      in wwf (args // {
      enable =  mbEnable // {
        buildInputs = [ lib ]
          ++ maybeAttr "buildInputs" [] mbEnable;
        configureFlags = [
          "--with-${name}-libs=${lib}/lib"
          "--with-${name}-includes=${lib}/include"
        ] ++ maybeAttr "configureFlags" [] mbEnable;
      };
    });
in
a.composableDerivation.composableDerivation {} (fix: {

  name = "grass-6.4.0RC6";

  buildInputs = [
    # gentoos package depends on gmath ? 
    a.pkgconfig
    a.flex a.bison a.libXmu a.libXext a.libXp a.libX11 a.libXt a.libSM a.libICE
    a.libXpm a.libXaw a.flex a.bison a.gdbm
    a.makeWrapper
  ];

  cfg = {
    _64bitSupport = config.grass."64bitSupport" or true;
    cursesSupport = config.grass.curses or true;
    gdalSupport = config.grass.gdal or true;
    pythonSupport = config.grass.python or true;
    wxwidgetsSupport = config.grass.wxwidgets or true;
    readlineSupport = config.grass.readline or true;
    jpegSupport = config.grass.jpeg or true;
    tiffSupport = config.grass.tiff or true;
    pngSupport = config.grass.png or true;
    tcltkSupport = config.grass.tcltk or true;
    postgresSupport = config.grass.postgres or true;
    mysqlSupport = config.grass.mysql or true;
    sqliteSupport = config.grass.sqlite or true;
    ffmpegSupport = config.grass.ffmpeg or true;
    openglSupport = config.grass.opengl or true;
    odbcSupport = config.grass.odbc or false; # fails to find libodbc - why ?
    fftwSupport = config.grass.fftw or true;
    blasSupport = config.grass.blas or true;
    lapackSupport = config.grass.lapack or true;
    cairoSupport = config.grass.cairo or true;
    motifSupport = config.grass.motif or true;
    freetypeSupport = config.grass.freetype or true;
    projSupport = config.grass.proj or true;
    opendwgSupport = config.grass.dwg or false;
    largefileSupport = config.grass.largefile or true;
  };

  # ?? NLS support:                no
  # ?? GLw support:                no
  # ?? DWG support:                no
  flags = {

    python = {
      configureFlags = [ "--with-python=${a.python}/bin/python-config" ];
      buildInputs = [a.python a.swig];
    };
    
  }
  // edf { name = "_64bit"; feat = "64bit"; }
  // wwfp a.ncurses { name = "curses"; }
  // wwfp a.gdal { name = "gdal"; }
  // wwfp a.wxGTK { name = "wxwidgets"; value = "${a.wxGTK}/bin/wx-config"; }
  // wwfp a.readline { name = "readline"; }
  // wwfp a.libjpeg { name = "jpeg"; }
  // wwfp a.libtiff { name = "tiff"; }
  // wwfp a.libpng { name = "png"; }
  // wwfp a.tk { name = "tcltk"; enable.buildInputs = [ a.tcl ]; }
  // wwfp a.postgresql { name = "postgres"; }
  // wwf {
    name = "mysql";
    enable = {
      buildInputs = [ a.mysql ];
      configureFlags = [
        "--with-mysql-libs=${a.mysql}/lib/mysql"
        "--with-mysql-includes=${a.mysql}/include/mysql"
      ];
    };
  }
  // wwfp a.sqlite { name = "sqlite"; }
  // wwf {
    name = "ffmpeg";
    enable = {
      configureFlags = [
        "--with-ffmpeg-libs=${a.ffmpeg}/lib"
        "--with-ffmpeg-includes=${a.ffmpeg}/include"
      ];
      # is there a nicer way to pass additional include directories?
      # this should work: --with-ffmpeg-includes=/usr/include/lib[av|sw]*
      # I did not try
      preConfigure = ''
        for dir in ${a.ffmpeg}/include/*; do
          if [ -d $dir ]; then
            NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$dir"
          fi
        done
      '';
      buildInputs = [a.ffmpeg];
    };
  }
  // wwfp a.mesa { name = "opengl"; }
  // wwfp a.unixODBC { name = "odbc"; }
  // wwfp a.fftw { name = "fftw"; }
  // wwf {
    name = "blas"; 
    enable.configureFlags = [ "--with-blas-libs=${a.blas}/lib" ];
  }
  // wwf {
    name = "lapack";
    enable.configureFlags = [ "--with-lapack-libs=${a.liblapack}/lib" ];
  }
  // wwfp a.cairo {
    name = "cairo";
    enable.buildInputs = [ a.fontconfig a.libXrender ];
  }
  // wwfp a.motif { name = "motif"; }
  // wwf {
    name="freetype";
    enable = {
      buildInputs = [ a.freetype ];
      configureFlags = [
        "--with-freetype-libs=${a.freetype}/lib"
        "--with-freetype-includes=${a.freetype}/include/freetype2"
      ];
    };
  }
  // wwfp a.proj { name = "proj"; enable.configureFlags = [ "--with-proj-share=${a.proj}/share"]; }
  // wwfp a.opendwg { name = "opendwg"; }
  // edf {
    name = "largefile";
  };
  /* ?
  // wwf {
    name = "x";
    enable.buildInputs = [];
  };
  */

  src = a.fetchurl {
    url = "http://grass.itc.it/grass64/source/grass-6.4.0RC6.tar.gz";
    sha256 = "043cxa224rd4q1x2mq7sl7ylnxv2vvb4k8laycgcjnp60nzhlmaz";
  };

  postInstall = ''
    e=$(echo $out/bin/grass*)
    mv $out/bin/{,.}$(basename $e)
    cat >> $e << EOF
    #!/bin/sh
    export PATH=${a.python}/bin:\$PATH
    export GRASS_WISH=\${a.tk}/bin/wish
    export GRASS_GUI=\''${GRASS_GUI:-wxpython}
    export SHELL=/bin/sh
    ${optionalString fix.fixed.cfg.wxwidgetsSupport ''export PYTHONPATH=\$PYTHONPATH\''${PYTHONPATH:+:}:$(toPythonPath ${a.wxPython})''}
    exec $out/bin/.$(basename $e)
    EOF
    chmod +x $e
  '';

  meta = {
    description = "free Geographic Information System (GIS) software used for geospatial data management and analysis, image processing, graphics/maps production, spatial modeling, and visualization";
    homepage = http://grass.itc.it/index.php;
    license = [ "GPL" ];
  };

})

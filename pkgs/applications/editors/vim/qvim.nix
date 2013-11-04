args@{...}: with args;


let inherit (args.composableDerivation) composableDerivation edf; in
composableDerivation {
  # use gccApple to compile on darwin
  mkDerivation = ( if stdenv.isDarwin
                   then stdenvAdapters.overrideGCC stdenv gccApple
                   else stdenv ).mkDerivation;
} (fix: {

    name = "qvim-7.4";

    enableParallelBuilding = true; # test this

    src = fetchgit {
      url = https://bitbucket.org/equalsraf/vim-qt.git ;
      rev = "4160bfd5c1380e899d2f426b494fc4f1cf6ae85e";
      sha256 = "1qa3xl1b9gqw66p71h53l7ibs4y3zfyj553jss70ybxaxchbhi5b";
    };

    preConfigure = assert (! stdenv.isDarwin); "";
    # # if darwin support is enabled, we want to make sure we're not building with
    # # OS-installed python framework
    # preConfigure
    #   = stdenv.lib.optionalString
    #     (stdenv.isDarwin && (config.vim.darwin or true)) ''
    #       # TODO: we should find a better way of doing this as, if the configure
    #       # file changes, we need to change these line numbers
    #       sed -i "5641,5644d" src/auto/configure
    #       sed -i "5648d" src/auto/configure
    #     '';

    configureFlags = [ "--with-vim-name=qvim" "--enable-gui=qt" "--with-features=${args.features}" ];

    nativeBuildInputs
      = [ ncurses pkgconfig libX11 libXext libSM libXpm libXt libXaw libXau
          libXmu libICE qt4];

    # prePatch = "cd src";
    
    # patches =
    #   [ ./patches/7.4.001 ./patches/7.4.002 ./patches/7.4.003 ./patches/7.4.004
    #     ./patches/7.4.005 ./patches/7.4.006 ./patches/7.4.007 ./patches/7.4.008
    #     ./patches/7.4.009 ./patches/7.4.010 ./patches/7.4.011 ./patches/7.4.012
    #     ./patches/7.4.013 ./patches/7.4.014 ./patches/7.4.015 ./patches/7.4.016
    #     ./patches/7.4.017 ./patches/7.4.018 ./patches/7.4.019 ./patches/7.4.020
    #     ./patches/7.4.021 ./patches/7.4.022 ./patches/7.4.023 ];

    # most interpreters aren't tested yet.. (see python for example how to do it)
    flags = {
        ftNix = {
          # because we cd to src in the main patch phase, we can't just add this
          # patch to the list, we have to apply it manually
          postPatch = ''
            cd runtime
            patch -p2 < ${./ft-nix-support.patch}
            cd ..
          '';
        };
      }
      // edf { name = "darwin"; } #Disable Darwin (Mac OS X) support.
      // edf { name = "xsmp"; } #Disable XSMP session management
      // edf { name = "xsmp_interact"; } #Disable XSMP interaction
      // edf { name = "mzscheme"; } #Include MzScheme interpreter.
      // edf { name = "perl"; feat = "perlinterp"; enable = { nativeBuildInputs = [perl]; };} #Include Perl interpreter.

      // edf {
        name = "python";
        feat = "pythoninterp";
        enable = {
          nativeBuildInputs = [ python ];
        } // lib.optionalAttrs stdenv.isDarwin {
          configureFlags
            = [ "--enable-pythoninterp=yes"
                "--with-python-config-dir=${python}/lib" ];
        };
      }

      // edf { name = "tcl"; enable = { nativeBuildInputs = [tcl]; }; } #Include Tcl interpreter.
      // edf { name = "ruby"; feat = "rubyinterp"; enable = { nativeBuildInputs = [ruby]; };} #Include Ruby interpreter.
      // edf { name = "lua" ; feat = "luainterp"; enable = { nativeBuildInputs = [lua]; configureFlags = ["--with-lua-prefix=${args.lua}"];};}
      // edf { name = "cscope"; } #Include cscope interface.
      // edf { name = "workshop"; } #Include Sun Visual Workshop support.
      // edf { name = "netbeans"; } #Disable NetBeans integration support.
      // edf { name = "sniff"; feat = "sniff" ; } #Include Sniff interface.
      // edf { name = "multibyte"; } #Include multibyte editing support.
      // edf { name = "hangulinput"; feat = "hangulinput" ;} #Include Hangul input support.
      // edf { name = "xim"; } #Include XIM input support.
      // edf { name = "fontset"; } #Include X fontset output support.
      // edf { name = "acl"; } #Don't check for ACL support.
      // edf { name = "gpm"; } #Don't use gpm (Linux mouse daemon).
      // edf { name = "nls"; enable = {nativeBuildInputs = [gettext];}; } #Don't support NLS (gettext()).
      ;

  cfg = {
    pythonSupport    = config.vim.python or true;
    rubySupport      = config.vim.ruby or true;
    nlsSupport       = config.vim.nls or false;
    tclSupport       = config.vim.tcl or false;
    multibyteSupport = config.vim.multibyte or false;
    cscopeSupport    = config.vim.cscope or false;
    netbeansSupport  = config.netbeans or true; # eg envim is using it

    # by default, compile with darwin support if we're compiling on darwin, but
    # allow this to be disabled by setting config.vim.darwin to false
    darwinSupport    = stdenv.isDarwin && (config.vim.darwin or true);

    # add .nix filetype detection and minimal syntax highlighting support
    ftNixSupport     = config.vim.ftNix or true;
  };

  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    rpath=`patchelf --print-rpath $out/bin/qvim`;
    for i in $nativeBuildInputs; do
      echo adding $i/lib
      rpath=$rpath:$i/lib
    done
    echo $nativeBuildInputs
    echo $rpath
    patchelf --set-rpath $rpath $out/bin/qvim
  '';

  dontStrip = 1;

  meta = with stdenv.lib; {
    description = "The most popular clone of the VI editor (Qt GUI fork)";
    homepage    = https://bitbucket.org/equalsraf/vim-qt/wiki/Home;
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.unix;
  };
})


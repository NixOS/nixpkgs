# install these packages into your profile. Then add
# ~/.nix-profile/gimp-version-plugins to your plugin list you can find at
# preferences -> Folders -> Plug-ins
# same applies for the scripts

{ pkgs, gimp }:
let
  inherit (pkgs) stdenv fetchurl pkgconfig glib fetchFromGitHub;
  inherit (gimp) targetPluginDir targetScriptDir;

  pluginDerivation = a: stdenv.mkDerivation ({
    prePhases = "extraLib";
    extraLib = ''
      installScripts(){
        mkdir -p ${targetScriptDir};
        for p in "$@"; do cp "$p" ${targetScriptDir}; done
      }
      installPlugins(){
        mkdir -p ${targetPluginDir};
        for p in "$@"; do cp "$p" ${targetPluginDir}; done
      }
    '';
  }
  // a
    # don't call this gimp-* unless you want nix replace gimp by a plugin :-)
  // { name = "${a.name}-${gimp.name}-plugin"; }
  );

  scriptDerivation = {name, src} : pluginDerivation {
    inherit name; phases = "extraLib installPhase";
    installPhase = "installScripts ${src}";
  };

 libLQR = pluginDerivation {
    name = "liblqr-1-0.4.1";
    # required by lqrPlugin, you don't havet to install this lib explicitely
    buildInputs = [ gimp ] ++ gimp.nativeBuildInputs;
    src = fetchurl {
      url = http://registry.gimp.org/files/liblqr-1-0.4.1.tar.bz2;
      sha256 = "02g90wag7xi5rjlmwq8h0qs666b1i2sa90s4303hmym40il33nlz";
    };
  };

in
rec {
  gap = pluginDerivation {
    /* menu:
       Video
    */
    name = "gap-2.6.0";
    buildInputs = [ gimp pkgconfig glib pkgs.intltool gimp.gtk ] ++ gimp.nativeBuildInputs;
    src = fetchurl {
      url = http://ftp.gimp.org/pub/gimp/plug-ins/v2.6/gap/gimp-gap-2.6.0.tar.bz2;
      sha256 = "1jic7ixcmsn4kx2cn32nc5087rk6g8xsrz022xy11yfmgvhzb0ql";
    };
    patchPhase = ''
      sed -e 's,^\(GIMP_PLUGIN_DIR=\).*,\1'"$out/${gimp.name}-plugins", \
       -e 's,^\(GIMP_DATA_DIR=\).*,\1'"$out/share/${gimp.name}", -i configure
    '';
    hardeningDisable = [ "format" ];
    meta = with stdenv.lib; {
      description = "The GIMP Animation Package";
      homepage = http://www.gimp.org;
      # The main code is given in GPLv3, but it has ffmpeg in it, and I think ffmpeg license
      # falls inside "free".
      license = with licenses; [ gpl3 free ];
    };
  };

  fourier = pluginDerivation rec {
    /* menu:
       Filters/Generic/FFT Forward
       Filters/Generic/FFT Inverse
    */
    name = "fourier-0.4.1";
    buildInputs = [ gimp pkgs.fftw  pkgconfig glib] ++ gimp.nativeBuildInputs;
    postInstall = "fail";
    installPhase = "installPlugins fourier";
    src = fetchurl {
      url = "http://registry.gimp.org/files/${name}.tar.gz";
      sha256 = "1pr3y3zl9w8xs1circdrxpr98myz9m8wfzy022al79z4pdanwvs1";
    };
  };

  focusblur = pluginDerivation rec {
    /* menu:
       Blur/Focus Blur
    */
    name = "focusblur-3.2.6";
    buildInputs = [ gimp pkgconfig pkgs.fftwSinglePrec ] ++ gimp.nativeBuildInputs;
    patches = [ ./patches/focusblur-glib.patch ];
    postInstall = "fail";
    installPhase = "installPlugins src/focusblur";
    src = fetchurl {
      url = "http://registry.gimp.org/files/${name}.tar.bz2";
      sha256 = "1gqf3hchz7n7v5kpqkhqh8kwnxbsvlb5cr2w2n7ngrvl56f5xs1h";
    };
  };

  resynthesizer = pluginDerivation {
    /* menu:
      Filters/Map/Resynthesize
      Filters/Enhance/Smart enlarge
      Filters/Enhance/Smart sharpen
      Filters/Enhance/Smart remove selection
    */
    name = "resynthesizer-0.16";
    buildInputs = [ gimp pkgs.fftw ] ++ gimp.nativeBuildInputs;
    src = fetchurl {
      url = http://www.logarithmic.net/pfh-files/resynthesizer/resynthesizer-0.16.tar.gz;
      sha256 = "1k90a1jzswxmajn56rdxa4r60v9v34fmqsiwfdxqcvx3yf4yq96x";
    };

    installPhase = "
      installPlugins resynth
      installScripts smart-{enlarge,remove}.scm
    ";
  };

  resynthesizer2 = pluginDerivation {
    /* menu:
      Filters/Map/Resynthesize
      Filters/Enhance/Smart enlarge
      Filters/Enhance/Smart sharpen
      Filters/Enhance/Smart remove selection
    */
    name = "resynthesizer-2.0.1";
    buildInputs = [ gimp pkgs.fftw pkgs.autoreconfHook ] 
      ++ gimp.nativeBuildInputs;
    makeFlags = "GIMP_LIBDIR=$out/lib/gimp/2.0/";
    src = fetchFromGitHub {
      owner = "bootchk";
      repo = "resynthesizer";
      rev = "2.0.1";
      sha256 = "1d214s0jsqxz83l9dd8vhnz3siw9fyw7xdhhir25ra7jiwxc99hd";
    };
  };

  texturize = pluginDerivation {
    name = "texturize-2.1";
    buildInputs = [ gimp ] ++ gimp.nativeBuildInputs;
    src = fetchurl {
      url = mirror://sourceforge/gimp-texturize/texturize-2.1_src.tgz;
      sha256 = "0cdjq25g3yfxx6bzx6nid21kq659s1vl9id4wxyjs2dhcv229cg3";
    };
    patchPhase = ''
      sed -i '/.*gimpimage_pdb.h.*/ d' src/*.c*
    '';
    installPhase = "installPlugins src/texturize";
  };

  waveletSharpen = pluginDerivation {
    /* menu:
      Filters/Enhance/Wavelet sharpen
    */
    name = "wavelet-sharpen-0.1.2";
    buildInputs = [ gimp ] ++ gimp.nativeBuildInputs;
    src = fetchurl {
      url = http://registry.gimp.org/files/wavelet-sharpen-0.1.2.tar.gz;
      sha256 = "0vql1k67i21g5ivaa1jh56rg427m0icrkpryrhg75nscpirfxxqw";
    };
    installPhase = "installPlugins src/wavelet-sharpen"; # TODO translations are not copied .. How to do this on nix?
  };

  lqrPlugin = pluginDerivation {
    /* menu:
       Layer/Liquid Rescale
    */
    name = "lqr-plugin-0.6.1";
    buildInputs = [ pkgconfig libLQR gimp ] ++ gimp.nativeBuildInputs;
    src = fetchurl {
      url = http://registry.gimp.org/files/gimp-lqr-plugin-0.6.1.tar.bz2;
      sha256 = "00hklkpcimcbpjly4rjhfipaw096cpy768g9wixglwrsyqhil7l9";
    };
    #postInstall = ''mkdir -p $out/nix-support; echo "${libLQR}" > "$out/nix-support/propagated-user-env-packages"'';
    installPhase = "installPlugins src/gimp-lqr-plugin";
  };

  gmic =
    pluginDerivation rec {
      name = "gmic-1.6.5.0";

      buildInputs = [pkgconfig pkgs.fftw pkgs.opencv gimp] ++ gimp.nativeBuildInputs;

      src = fetchurl {
        url = http://gmic.eu/files/source/gmic_1.6.5.0.tar.gz;
        sha256 = "1vb6zm5zpqfnzxjvb9yfvczaqacm55rf010ib0yk9f28b17qrjgb";
      };

      sourceRoot = "${name}/src";

      buildFlags = "gimp";

      installPhase = "installPlugins gmic_gimp";

      meta = {
        description = "Script language for image processing which comes with its open-source interpreter";
        homepage = http://gmic.eu/gimp.shtml;
        license = stdenv.lib.licenses.cecill20;
        /*
        The purpose of this Free Software license agreement is to grant users
        the right to modify and redistribute the software governed by this
        license within the framework of an open source distribution model.
        [ ... ] */
      };
  };

  # this is more than a gimp plugin !
  # either load the raw image with gimp (and the import dialog will popup)
  # or use the binary
  ufraw = pluginDerivation rec {
    name = "ufraw-0.19.2";
    buildInputs = [pkgs.gtkimageview pkgs.lcms gimp] ++ gimp.nativeBuildInputs;
      # --enable-mime - install mime files, see README for more information
      # --enable-extras - build extra (dcraw, nikon-curve) executables
      # --enable-dst-correction - enable DST correction for file timestamps.
      # --enable-contrast - enable the contrast setting option.
      # --enable-interp-none: enable 'None' interpolation (mostly for debugging).
      # --with-lensfun: use the lensfun library - experimental feature, read this before using it.
      # --with-prefix=PREFIX - use also PREFIX as an input prefix for the build
      # --with-dosprefix=PREFIX - PREFIX in the the prefix in dos format (needed only for ms-window
    configureFlags = "--enable-extras --enable-dst-correction --enable-contrast";

    src = fetchurl {
      url = "mirror://sourceforge/ufraw/${name}.tar.gz";
      sha256 = "1lxba7pb3vcsq94dwapg9bk9mb3ww6r3pvvcyb0ah5gh2sgzxgkk";
    };
    installPhase = "
      installPlugins ufraw-gimp
      mkdir -p $out/bin
      cp ufraw $out/bin
    ";
  };

  gimplensfun = pluginDerivation rec {
    version = "0.2.4";
    name = "gimplensfun-${version}";

    src = fetchFromGitHub {
      owner = "seebk";
      repo = "GIMP-Lensfun";
      rev = version;
      sha256 = "0zlmp9v732qmzj083mnk5z421s57mnckmpjhiw890wmmwzj2lhxz";
    };

    buildInputs = [ gimp pkgconfig glib gimp.gtk pkgs.lensfun pkgs.exiv2 ];

    installPhase = "
      installPlugins gimp-lensfun
    ";

    meta = {
      description = "GIMP plugin to correct lens distortion using the lensfun library and database";

      homepage = http://lensfun.sebastiankraft.net/;

      license = stdenv.lib.licenses.gpl3Plus;
      maintainers = [ ];
      platforms = stdenv.lib.platforms.gnu;
    };
  };

  /* =============== simple script files ==================== */

  # also have a look at enblend-enfuse in all-packages.nix
  exposureBlend = scriptDerivation {
    name = "exposure-blend";
    src = fetchurl {
      url = http://tir.astro.utoledo.edu/jdsmith/code/eb/exposure-blend.scm;
      sha256 = "1b6c9wzpklqras4wwsyw3y3jp6fjmhnnskqiwm5sabs8djknfxla";
    };
  };

  lightning = scriptDerivation {
    name = "Lightning";
    src = fetchurl {
      url = http://registry.gimp.org/files/Lightning.scm;
      sha256 = "c14a8f4f709695ede3f77348728a25b3f3ded420da60f3f8de3944b7eae98a49";
    };
  };

  /* space in name trouble ?

  rainbowPlasma = scriptDerivation {
    # http://registry.gimp.org/node/164
    name = "rainbow-plasma";
    src = fetchurl {
      url = "http://registry.gimp.org/files/Rainbow Plasma.scm";
      sha256 = "34308d4c9441f9e7bafa118af7ec9540f10ea0df75e812e2f3aa3fd7b5344c23";
      name = "Rainbow-Plasma.scm"; # nix doesn't like spaces, does it?
    };
  };
  */

  /* doesn't seem to be working :-(
  lightningGate = scriptDerivation {
    # http://registry.gimp.org/node/153
    name = "lightning-gate";
    src = fetchurl {
      url = http://registry.gimp.org/files/LightningGate.scm;
      sha256 = "181w1zi9a99kn2mfxjp43wkwcgw5vbb6iqjas7a9mhm8p04csys2";
    };
  };
  */

}

# install these packages into your profile. Then add
# ~/.nix-profile/gimp-version-plugins to your plugin list you can find at
# preferences -> Folders -> Plug-ins
# same applies for the scripts

{ pkgs, gimp }:
let
  inherit (pkgs) stdenv fetchurl pkgconfig gtkLibs;
  inherit (gtkLibs) glib;
  targetPluginDir = "$out/${gimp.name}-plugins";
  targetScriptDir = "$out/${gimp.name}-scripts";
  prefix = "plugin-gimp-";

  pluginDerivation = a: stdenv.mkDerivation ({
    prePhases = "extraLib";
    extraLib = ''
      installScripts(){
        ensureDir ${targetScriptDir};
        for p in "$@"; do cp "$p" ${targetScriptDir}; done
      }
      installPlugins(){
        ensureDir ${targetPluginDir};
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
    buildInputs = [ gimp ] ++ gimp.buildInputs;
    src = fetchurl {
      url = http://registry.gimp.org/files/liblqr-1-0.4.1.tar.bz2;
      sha256 = "02g90wag7xi5rjlmwq8h0qs666b1i2sa90s4303hmym40il33nlz";
    };
  };

in
rec {
  fourier = pluginDerivation {
    /* menu:
       Filters/Generic/FFT Forward
       Filters/Generic/FFT Inverse
    */
    name = "fourier-0.3.3";
    buildInputs = [ gimp pkgs.fftwSinglePrec  pkgconfig glib] ++ gimp.buildInputs;
    postInstall = "fail";
    installPhase = "installPlugins fourier";
    src = fetchurl {
      url = http://people.via.ecp.fr/~remi/soft/gimp/fourier-0.3.3.tar.gz;
      sha256 = "0xxgp0lrjxsj54sgygi31c7q41jkqzn0v18qyznrviv8r099v29p";
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
    buildInputs = [ gimp pkgs.fftw ] ++ gimp.buildInputs;
    src = fetchurl {
      url = http://www.logarithmic.net/pfh-files/resynthesizer/resynthesizer-0.16.tar.gz;
      sha256 = "1k90a1jzswxmajn56rdxa4r60v9v34fmqsiwfdxqcvx3yf4yq96x";
    };

    installPhase = "
      installPlugins resynth
      installScripts smart-{enlarge,remove}.scm
    ";
  };

  texturize = pluginDerivation {
    name = "texturize-2.1";
    buildInputs = [ gimp ] ++ gimp.buildInputs;
    src = fetchurl {
      url = http://prdownloads.sourceforge.net/gimp-texturize/texturize-2.1_src.tgz;
      sha256 = "0cdjq25g3yfxx6bzx6nid21kq659s1vl9id4wxyjs2dhcv229cg3";
    };
    installPhase = "installPlugins src/texturize";
  };

  waveletSharpen = pluginDerivation {
    /* menu:
      Filters/Enhance/Wavelet sharpen
    */
    name = "wavelet-sharpen-0.1.2";
    buildInputs = [ gimp ] ++ gimp.buildInputs;
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
    buildInputs = [ pkgconfig libLQR gimp ] ++ gimp.buildInputs;
    src = fetchurl {
      url = http://registry.gimp.org/files/gimp-lqr-plugin-0.6.1.tar.bz2;
      sha256 = "00hklkpcimcbpjly4rjhfipaw096cpy768g9wixglwrsyqhil7l9";
    };
    #postInstall = ''ensureDir $out/nix-support; echo "${libLQR}" > "$out/nix-support/propagated-user-env-packages"'';
    installPhase = "installPlugins src/gimp-lqr-plugin";
  };

  /* =============== simple script files ==================== */

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

# install these packages into your profile. Then add
# ~/.nix-profile/gimp-version-plugins to your plugin list you can find at
# preferences -> Folders -> Plug-ins
# same applies for the scripts

{ config, pkgs, gimp }:
let
  inherit (pkgs) stdenv fetchurl pkgconfig intltool glib fetchFromGitHub;
  inherit (gimp) targetPluginDir targetScriptDir;

  pluginDerivation = a: stdenv.mkDerivation ({
    prePhases = "extraLib";
    extraLib = ''
      installScripts(){
        mkdir -p $out/${targetScriptDir};
        for p in "$@"; do cp "$p" $out/${targetScriptDir}; done
      }
      installPlugins(){
        mkdir -p $out/${targetPluginDir};
        for p in "$@"; do cp "$p" $out/${targetPluginDir}; done
      }
    '';
  }
  // a
  // {
      name = "gimp-plugin-${a.name or "${a.pname}-${a.version}"}";
      buildInputs = [ gimp gimp.gtk glib ] ++ (a.buildInputs or []);
      nativeBuildInputs = [ pkgconfig intltool ] ++ (a.nativeBuildInputs or []);
    }
  );

  scriptDerivation = {name, src} : pluginDerivation {
    inherit name; phases = "extraLib installPhase";
    installPhase = "installScripts ${src}";
  };

in

stdenv.lib.makeScope pkgs.newScope (self: with self; {
  gap = pluginDerivation {
    /* menu:
       Video
    */
    name = "gap-2.6.0";
    src = fetchurl {
      url = https://ftp.gimp.org/pub/gimp/plug-ins/v2.6/gap/gimp-gap-2.6.0.tar.bz2;
      sha256 = "1jic7ixcmsn4kx2cn32nc5087rk6g8xsrz022xy11yfmgvhzb0ql";
    };
    patchPhase = ''
      sed -e 's,^\(GIMP_PLUGIN_DIR=\).*,\1'"$out/${gimp.name}-plugins", \
       -e 's,^\(GIMP_DATA_DIR=\).*,\1'"$out/share/${gimp.name}", -i configure
    '';
    hardeningDisable = [ "format" ];
    meta = with stdenv.lib; {
      description = "The GIMP Animation Package";
      homepage = https://www.gimp.org;
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
    buildInputs = with pkgs; [ fftw ];
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
    buildInputs = with pkgs; [ fftwSinglePrec ];
    patches = [ ./patches/focusblur-glib.patch ];
    postInstall = "fail";
    installPhase = "installPlugins src/focusblur";
    src = fetchurl {
      url = "http://registry.gimp.org/files/${name}.tar.bz2";
      sha256 = "1gqf3hchz7n7v5kpqkhqh8kwnxbsvlb5cr2w2n7ngrvl56f5xs1h";
    };
    meta.broken = true;
  };

  resynthesizer = pluginDerivation rec {
    /* menu:
      Edit/Fill with pattern seamless...
      Filters/Enhance/Heal selection...
      Filters/Enhance/Heal transparency...
      Filters/Enhance/Sharpen by synthesis...
      Filters/Enhance/Uncrop...
      Filters/Map/Style...
      Filters/Render/Texture...
    */
    pname = "resynthesizer";
    version = "2.0.3";
    buildInputs = with pkgs; [ fftw ];
    nativeBuildInputs = with pkgs; [ autoreconfHook ];
    makeFlags = [ "GIMP_LIBDIR=${placeholder "out"}/lib/gimp/2.0" ];
    src = fetchFromGitHub {
      owner = "bootchk";
      repo = "resynthesizer";
      rev = "v${version}";
      sha256 = "1jwc8bhhm21xhrgw56nzbma6fwg59gc8anlmyns7jdiw83y0zx3j";
    };
  };

  texturize = pluginDerivation {
    name = "texturize-2.2.2017-07-28";
    src = fetchFromGitHub {
      owner = "lmanul";
      repo = "gimp-texturize";
      rev = "de4367f71e40fe6d82387eaee68611a80a87e0e1";
      sha256 = "1zzvbczly7k456c0y6s92a1i8ph4ywmbvdl8i4rcc29l4qd2z8fw";
    };
    installPhase = "installPlugins src/texturize";
    meta.broken = true; # https://github.com/lmanul/gimp-texturize/issues/1
  };

  waveletSharpen = pluginDerivation {
    /* menu:
      Filters/Enhance/Wavelet sharpen
    */
    name = "wavelet-sharpen-0.1.2";
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
    buildInputs = with pkgs; [ liblqr1 ];
    src = fetchurl {
      url = http://registry.gimp.org/files/gimp-lqr-plugin-0.6.1.tar.bz2;
      sha256 = "00hklkpcimcbpjly4rjhfipaw096cpy768g9wixglwrsyqhil7l9";
    };
    #postInstall = ''mkdir -p $out/nix-support; echo "${liblqr1}" > "$out/nix-support/propagated-user-env-packages"'';
    installPhase = "installPlugins src/gimp-lqr-plugin";
  };

  gmic = pkgs.gmic.gimpPlugin;

  ufraw = pkgs.ufraw.gimpPlugin;

  gimplensfun = pluginDerivation rec {
    version = "0.2.4";
    name = "gimplensfun-${version}";

    src = fetchFromGitHub {
      owner = "seebk";
      repo = "GIMP-Lensfun";
      rev = version;
      sha256 = "0zlmp9v732qmzj083mnk5z421s57mnckmpjhiw890wmmwzj2lhxz";
    };

    buildInputs = with pkgs; [ lensfun exiv2 ];

    installPhase = "
      installPlugins gimp-lensfun
    ";

    meta = {
      description = "GIMP plugin to correct lens distortion using the lensfun library and database";

      homepage = http://lensfun.sebastiankraft.net/;

      license = stdenv.lib.licenses.gpl3Plus;
      maintainers = [ ];
      platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;
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

} // stdenv.lib.optionalAttrs (config.allowAliases or true) {

  resynthesizer2 = resynthesizer;

})

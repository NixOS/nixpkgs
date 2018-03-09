{ stdenv, fetchFromGitHub, fetchgit, makeWrapper, gcc, fetchpatch,
  curl, glew, glfw, gnome2, jansson, libsamplerate, libzip,
  pkgconfig, rtaudio, rtmidi3,
  ... }:

with stdenv.lib;

let
  plugins = {
    # fetch official Plugins
    # ----------------------
    Fundamental = fetchgit {
      url    = "https://github.com/VCVRack/Fundamental.git";
      rev    = "v0.5.1";
      sha256 = "0dawi83463fiml03d1d40r638rnzgxlvc4d1744gdal2rmhrycva";
    };
    Befco = fetchgit {
      url    = "https://github.com/VCVRack/Befaco.git";
      rev    = "v0.5.0";
      sha256 = "0v62ffahybff1ipz85zg30sih56wkfdkbbhs9qz10s6k0nr7i63r";
    };
    ESeries = fetchgit {
      url    = "https://github.com/VCVRack/Eseries.git";
      rev    = "v0.5.0";
      sha256 = "1kwvbsi5vjljlgs6annh7qkxzakjyhmx05qrfhqk9llxs8r8f0d7";
    };
    AudibleInstruments = fetchgit {
      url    = "https://github.com/VCVRack/AudibleInstruments.git";
      rev    = "v0.5.0";
      sha256 = "0paj9iryx3xd46ilipsyiq6516zhzpgciijqyjl1nrji4g7v7l5f";
    };

    # fetch additional Plugins
    # ------------------------
    # todo : make these `nixos.vcvrackPlugins.<plugin-name>`
    AmalgamatedHarmonics = fetchgit {
      url    = "https://github.com/jhoar/AmalgamatedHarmonics.git";
      rev    = "v0.5.8";
      sha256 = "1k9641p2lmy549iaj2gmj9wsj5h611h1n7255bq3z6bmm4pdv89r";
    };
    AS = fetchgit {
      url    = "https://github.com/AScustomWorks/AS.git";
      rev    = "0.5.6";
      sha256 = "0jp0ba264a4c4gydams3k4964mh3y47gmbpnhcapcdkq7q09ryv5";
    };
    BogaudioModules = fetchgit {
      url    = "https://github.com/bogaudio/BogaudioModules.git";
      rev    = "v0.5.3";
      sha256 = "10apg23wyzsk1y41241jcpkj1047h9ygfk45fcrf44sj310yw0ji";
    };
    Dekstop = fetchgit {
      url    = "https://github.com/dekstop/vcvrackplugins_dekstop";
      rev    = "v0.5.0";
      sha256 = "1kqywcgf7vacg0f471v9xlvrsdqr64m6ivq13j0x3ka6j6nziyjq";
    };
    HetrickCV = fetchgit {
      url    = "https://github.com/mhetrick/hetrickcv.git";
      rev    = "0.5.4";
      sha256 = "0f047y4rfzfyzpcsz58d9kjb2dg4xi59dzzs35i0phz1vkgxvm0d";
    };
    NauModular = fetchgit {
      url    = "https://github.com/naus3a/NauModular.git";
      rev    = "0.5.2";
      sha256 = "0mh2yyranzy8fzi9kcw6z534s788gzxzyrng38cwyw02jkkk05m9";
    };
    RJModules = fetchgit {
      url    = "https://github.com/Miserlou/RJModules.git";
      rev    = "0.5.0";
      sha256 = "1w9w578fyfkxrzz9s8xap3696id8ibhj2bzap8zdg0k7vw609jrl";
    };
    StellareLink =  fetchgit {
      url    = "https://github.com/stellare-modular/vcv-link.git";
      rev    = "0.5.1";
      sha256 = "1b7rrdhfqrwrffxaswdqrykq7k8sxsbxr62pi3ggfphqrgkijspr";
    };
  };

in
stdenv.mkDerivation rec {
  name = "vcvrack-${version}";
  version = "0.5.1";

  # need to use fetchgit here to pull submodules as well
  src = fetchgit {
    url    = "https://github.com/VCVRack/Rack.git";
    rev    = "v${version}";
    sha256 = "0zy1splbir50iz12vlpxbpix1qx6lrjmqyb4fy7nz03sz8dij59a";
  };


  buildInputs = [
    curl
    glew
    glfw
    gnome2.gtk.dev
    jansson
    libsamplerate
    libzip
    makeWrapper
    pkgconfig
    rtaudio
    rtmidi3
  ];


  # include the plugins
  prePatch = ''
      ${builtins.toString (flip mapAttrsToList plugins (k: v: ''
        echo ${k}
        mkdir -p plugins/${k}
        cp -a ${v}/* plugins/${k}
      ''))}
    '';

  patches = [
    (fetchpatch {
      name   = "Fix-Xmonad.patch";
      sha256 = "00qakp95xjrsv6vapmkvwyavg2y6mbdvqzq4zprgnfzm1jfh9bry";
      url    = "https://github.com/sorki/Rack/commit/e1a81a44e400c23b5239d941e9cc4943009ea714.patch";
    })
  ];

  postPatch = ''
    # patch RtAudio include
    substituteInPlace src/core/AudioInterface.cpp \
      --replace RtAudio.h rtaudio/RtAudio.h

    # otherwise we will not find the fonts and pulgins
    sed src/asset.cpp -i -e "46s@.*@dir = \"$out/share/vcvrack\"\;@"
    sed src/asset.cpp -i -e "49s@.*@dir = \"$out/share/vcvrack\"\;@"
  '';

  buildPhase = ''
    # call make plugins separately to not override the VERSION parameter
    make allplugins
    # VERSION parameter is important to build a release version,
    # which contains the plugin manager.
    make VERSION=${version}
  '';

  # there is no `make install` so we override this phase
  installPhase = ''
    mkdir -p $out/{bin,share/vcvrack}
    cp Rack  $out/share/vcvrack
    ln -s    $out/share/vcvrack/Rack $out/bin/Rack
    ln -s    $out/share/vcvrack/Rack $out/bin/VCVRack

    cp -r res     $out/share/vcvrack/
    cp -r plugins $out/share/vcvrack/ # todo : only copy libs
  '';

  meta = with stdenv.lib; {
    description     = "Open-source virtual modular synthesizer";
    longDescription = ''
      Rack is the engine for the VCV open-source virtual Eurorack DAW.
    '';
    homepage     = https://vcvrack.com/;
    license      = with licenses; [ bsd3 mit ];
    maintainers  = [ maintainers.mrVanDalo ];
    platforms    = platforms.linux;
  } ;
}

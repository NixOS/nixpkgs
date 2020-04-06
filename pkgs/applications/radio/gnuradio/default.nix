{ callPackage
, CoreAudio
, python2
, python3
, lib
}:

rec {
  # All the defaults
  unwrapped3_7 = callPackage ./3.7.nix { };
  # includes documentation
  unwrapped3_7-full = callPackage ./3.7.nix {
    enableSphinx = true;
    enableDoxygen = true;
    enableComedi = true;
  };
  unwrapped3_7-no-gui = callPackage ./3.7.nix {
    enablePython = false;
    enableCompanion = false;
    enableQtgui = false;
    enableWxgui = false;
    enableUtils = false;
  };
  # To be used as a library - no gui components are installed
  gnuradio3_7-no-gui = unwrapped3_7-no-gui;
  gnuradio3_7 = callPackage ./wrapper.nix {
    plugins = plugins3_7;
    unwrapped = unwrapped3_7;
    python = python2;
  };
  gnuradio3_7-with-packages = callPackage ./wrapper.nix {
    plugins = plugins3_7;
    unwrapped = unwrapped3_7;
    python = python2;
    extraPaths = lib.attrValues plugins3_7;
  };
  gnuradio3_7-full = callPackage ./wrapper.nix {
    plugins = plugins3_7;
    unwrapped = unwrapped3_7-full;
    python = python2;
    extraPaths = lib.attrValues plugins3_7;
  };
  plugins3_7 = rec {
    ais = callPackage ./plugins/ais.nix { gnuradio = unwrapped3_7; gr-osmosdr = osmosdr;};
    gsm = callPackage ./plugins/gsm.nix { gnuradio = unwrapped3_7; gr-osmosdr = osmosdr;};
    rds = callPackage ./plugins/rds.nix { gnuradio = unwrapped3_7; };
    nacl = callPackage ./plugins/nacl.nix { gnuradio = unwrapped3_7; };
    limesdr = callPackage ./plugins/limesdr.nix { gnuradio = unwrapped3_7; };
    osmosdr = callPackage ./plugins/osmosdr.nix { gnuradio = unwrapped3_7; };
  };
}

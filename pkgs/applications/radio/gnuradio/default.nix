{ callPackage
, CoreAudio
, python2
, python3
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
    unwrapped = unwrapped3_7;
    python = python2;
  };
  gnuradio3_7-with-packages = callPackage ./wrapper.nix {
    unwrapped = unwrapped3_7;
    python = python2;
    # TODO
    # extraPackages = []
  };
}

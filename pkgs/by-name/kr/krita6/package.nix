{
  lib,
  fetchFromGitLab,
  symlinkJoin,
  binaryPlugins ? [
    # TODO: Add Qt6 version of krita-plugin-gmic
  ],
  krita,
  krita-unwrapped,
}:
krita.override {
  krita-unwrapped = (krita-unwrapped.override { isQt6 = true; }).overrideAttrs (
    finalAttrs: _: {
      version = "6.0.0-prealpha-5a2359089a";
      src = fetchFromGitLab {
        domain = "invent.kde.org";
        owner = "graphics";
        repo = "krita";
        rev = "5a2359089a0b24f67c548cf7a3ce820bc3f930f0";
        hash = "sha256-SsFD0fuGRYWETcYByET9LUpYM1aoahTWqN1/rUBWAw4=";
      };
      patches = [ ];
    }
  );
  inherit binaryPlugins;
}

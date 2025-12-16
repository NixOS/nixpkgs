{
  fetchFromGitLab,
  krita-unwrapped,
}:
# TODO: krita-plugin-gmic only builds with Qt5, so we simply use unwrapped version here
(krita-unwrapped.override { isQt6 = true; }).overrideAttrs (
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
)

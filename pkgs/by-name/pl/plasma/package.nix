{
  stdenv,
  lib,
  fetchFromGitHub,
  juce,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plasma";
  version = "1.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Dimethoxy";
    repo = "Plasma";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XfHYGZRgZ2fuVIasp4CSnwmO/MW254b6fgFAQmVug2Q=";
  };

  strictDeps = true;

  nativeBuildInputs = [ juce.projucerHook ];

  jucerFile = "Plasma.jucer";

  meta = {
    description = "Asymmetrical Distortion Audio Plugin";
    homepage = "https://github.com/Dimethoxy/Plasma";
    license = lib.licenses.agpl3Plus;
    inherit (juce.projucerHook.meta) platforms;
    maintainers = [ lib.maintainers.bandithedoge ];
  };
})

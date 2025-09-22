{
  lib,
  fetchFromSourcehut,
  libexif,
  libraw,
  libtiff,
  meson,
  ninja,
  opencv4,
  pkg-config,
  scdoc,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "postprocessd";
  version = "0.3.0";

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "postprocessd";
    rev = finalAttrs.version;
    hash = "sha256-xqEjjAv27TUrEU/5j8Um7fTFjmIYZovyJCccbtHPuGo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  depsBuildBuild = [
    pkg-config
  ];

  buildInputs = [
    libexif
    libraw
    libtiff
    opencv4
  ];

  strictDeps = true;

  meta = {
    description = "Queueing megapixels post-processor";
    homepage = "https://git.sr.ht/~martijnbraam/postprocessd";
    changelog = "https://git.sr.ht/~martijnbraam/postprocessd/refs/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Luflosi ];
    platforms = lib.platforms.linux;
    mainProgram = "postprocess-single";
  };
})

{
  lib,
  stdenv,
  fetchzip,
  libX11,
  libXft,
  libXrandr,
  pkg-config,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "katriawm";
  version = "25.09";

  src = fetchzip {
    url = "https://www.uninformativ.de/git/katriawm/archives/katriawm-v${finalAttrs.version}.tar.gz";
    hash = "sha256-gguNXG16TN2fRkbKs7/U2d/oyDduTl3qBMEZPQtuKnU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    libXft
    libXrandr
  ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  makeFlags = [
    "-C"
    "src"
  ];

  installFlags = [ "prefix=$(out)" ];

  postPatch = ''
    substituteInPlace src/config.mk \
      --replace pkg-config "$PKG_CONFIG"
  '';

  passthru.updateScript = gitUpdater {
    url = "https://www.uninformativ.de/git/katriawm.git/";
    rev-prefix = "v";
  };

  meta = {
    homepage = "https://www.uninformativ.de/git/katriawm/file/README.html";
    description = "Non-reparenting, dynamic window manager with decorations";
    license = lib.licenses.mit;
    mainProgram = "katriawm";
    maintainers = [ ];
    inherit (libX11.meta) platforms;
  };
})

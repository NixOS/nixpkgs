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
  version = "25.04";

  src = fetchzip {
    url = "https://www.uninformativ.de/git/katriawm/archives/katriawm-v${finalAttrs.version}.tar.gz";
    hash = "sha256-3cWgLz4BO1X8KkhoQp3hbq5XAx9NzDhsIL3fDSQaG5M=";
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

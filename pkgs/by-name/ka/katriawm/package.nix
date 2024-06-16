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
  version = "23.08";

  src = fetchzip {
    url = "https://www.uninformativ.de/git/katriawm/archives/katriawm-v${finalAttrs.version}.tar.gz";
    hash = "sha256-IWviLboZz421/Amz/QG4o8jYaG8Y/l5PvmvXfK5nzJE=";
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
    description = "A non-reparenting, dynamic window manager with decorations";
    license = lib.licenses.mit;
    mainProgram = "katriawm";
    maintainers = [ lib.maintainers.AndersonTorres ];
    inherit (libX11.meta) platforms;
  };
})

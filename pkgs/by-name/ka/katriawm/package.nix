{
  lib,
  stdenv,
  fetchzip,
  libx11,
  libxft,
  libxrandr,
  pkg-config,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "katriawm";
  version = "26.07";

  src = fetchzip {
    url = "https://www.uninformativ.de/git/katriawm/archives/katriawm-v${finalAttrs.version}.tar.gz";
    hash = "sha256-kbCNuqJCmfVqfrVsNhFNHA5hmahajFU0rsOjuZK6Cmk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxft
    libxrandr
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
    inherit (libx11.meta) platforms;
  };
})

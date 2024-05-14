{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libX11,
  libXft,
  libXrandr,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bevelbar";
  version = "23.08";

  src = fetchurl {
    url = "https://www.uninformativ.de/git/bevelbar/archives/bevelbar-v${finalAttrs.version}.tar.gz";
    hash = "sha256-4wMSPi9tu+z1AW2uvPefxkeT/5DYo2oJybhNnpe82QU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    libXft
    libXrandr
  ];

  makeFlags = [ "prefix=$(out)" ];

  passthru.updateScript = gitUpdater {
    url = "https://www.uninformativ.de/git/bevelbar.git/";
    rev-prefix = "v";
  };

  meta = {
    homepage = "https://www.uninformativ.de/git/bevelbar/file/README.html";
    description = "X11 status bar with beveled borders";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      AndersonTorres
      neeasade
    ];
    platforms = lib.platforms.linux;
  };
})

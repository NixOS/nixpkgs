{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  libxft,
  libxrandr,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bevelbar";
  version = "26.08";

  src = fetchurl {
    url = "https://www.uninformativ.de/git/bevelbar/archives/bevelbar-v${finalAttrs.version}.tar.gz";
    hash = "sha256-pc6tEwcdECBv1n5o2c8tV4UVumuOhJHye4T1+ny3GAk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxft
    libxrandr
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
      neeasade
    ];
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libconfuse,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "genimage";
  version = "20";

  src = fetchFromGitHub {
    owner = "pengutronix";
    repo = "genimage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6pKqvpoEQWebubl6K5FzEAv2aUsBXgOBEAdcCwARkrU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libconfuse
    gettext
  ];

  postInstall = ''
    # As there is no manpage or built-in --help, add the README file for
    # documentation.
    docdir="$out/share/doc/genimage"
    mkdir -p "$docdir"
    cp -v README.rst "$docdir"
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://git.pengutronix.de/cgit/genimage";
    description = "Generate filesystem images from directory trees";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bjornfor ];
    mainProgram = "genimage";
  };
})

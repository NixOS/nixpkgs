{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libconfuse,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "genimage";
  version = "19";

  src = fetchurl {
    url = "https://public.pengutronix.de/software/genimage/genimage-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-fsT8uGVmKosv8gKEgZBE/6hBN788oW+3SXASkbwB8Qg=";
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

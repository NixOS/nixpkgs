{
  lib,
  stdenv,
  fetchurl,
  imagemagick,
  desktopToDarwinBundle,
  motif,
  ncurses,
  libX11,
  libXt,
  gdb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ddd";
  version = "3.4.0";

  src = fetchurl {
    url = "mirror://gnu/ddd/ddd-${finalAttrs.version}.tar.gz";
    hash = "sha256-XUy8iguwRYVDhm1nkwjFOj7wZuQC/loZGOGWmKPTWA8=";
  };

  postPatch = ''
    substituteInPlace ddd/Ddd.in \
      --replace-fail 'debuggerCommand:' 'debuggerCommand: ${gdb}/bin/gdb'
  '';

  nativeBuildInputs = [
    imagemagick
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    motif
    ncurses
    libX11
    libXt
  ];

  # ioctl is not found without this flag. fixed in next release
  # Upstream issue ref: https://savannah.gnu.org/bugs/index.php?64188
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin { NIX_CFLAGS_COMPILE = "-DHAVE_SYS_IOCTL_H"; };

  configureFlags = [
    "--enable-builtin-manual"
    "--enable-builtin-app-defaults"
  ];

  # From MacPorts: make will build the executable "ddd" and the X resource
  # file "Ddd" in the same directory, as HFS+ is case-insensitive by default
  # this will loosely FAIL
  makeFlags = [ "EXEEXT=exe" ];
  enableParallelBuilding = true;

  postInstall = ''
    mv $out/bin/dddexe $out/bin/ddd
    convert icons/ddd.xbm ddd.png
    install -D ddd.png $out/share/icons/hicolor/48x48/apps/ddd.png
  '';

  meta = {
    changelog = "https://www.gnu.org/software/ddd/news.html";
    description = "Graphical front-end for command-line debuggers";
    homepage = "https://www.gnu.org/software/ddd";
    license = lib.licenses.gpl3Only;
    mainProgram = "ddd";
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.unix;
  };
})

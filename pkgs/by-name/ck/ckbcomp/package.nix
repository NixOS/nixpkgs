{
  lib,
  stdenv,
  fetchFromGitLab,
  perl,
  xkeyboard_config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ckbcomp";
  version = "1.246";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "installer-team";
    repo = "console-setup";
    rev = finalAttrs.version;
    sha256 = "sha256-f6WGlxmNBgjaO5uMQH3J382GCHfJZLp7QWL0n37KUaY=";
  };

  buildInputs = [ perl ];

  patchPhase = ''
    substituteInPlace Keyboard/ckbcomp --replace "/usr/share/X11/xkb" "${xkeyboard_config}/share/X11/xkb"
    substituteInPlace Keyboard/ckbcomp --replace "rules = 'xorg'" "rules = 'base'"
  '';

  dontBuild = true;

  installPhase = ''
    install -Dm0555 -t $out/bin Keyboard/ckbcomp
    install -Dm0444 -t $out/share/man/man1 man/ckbcomp.1
  '';

  meta = {
    description = "Compiles a XKB keyboard description to a keymap suitable for loadkeys";
    homepage = "https://salsa.debian.org/installer-team/console-setup";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "ckbcomp";
  };
})

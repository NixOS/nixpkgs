{
  fetchurl,
  lib,
  stdenv,
  runCommand,
  perl,
  screen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "screenie";
  version = "20120406";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/screenie/screenie-${finalAttrs.version}.tar.gz";
    hash = "sha256-g+XmSdOZTgPrkqDQoEoOx07jlzqDwcpLq5KPPTt22HA=";
  };

  buildInputs = [
    perl
    screen
  ];

  postPatch = ''
    substituteInPlace screenie --replace-fail "my \$SCREEN = 'screen';" "my \$SCREEN = '${lib.getExe' screen "screen"}';"
  '';

  postInstall = ''
    mkdir -p $out/{bin,share/man/man1}
    cp screenie $out/bin/
    cp screenie.1 $out/share/man/man1/
  '';

  passthru.tests = {
    help =
      runCommand "${finalAttrs.pname}-test-help"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          screenie --help 2>&1 > help.txt || true
          grep "screenie - terminal screen-session handler\." help.txt
          touch $out
        '';
  };

  meta = {
    description = "Lightweight GNU screen wrapper";
    homepage = "https://sourceforge.net/projects/screenie/";
    license = lib.licenses.artistic1;
    longDescription = ''
      screenie is a small and lightweight screen wrapper designed to simplify session selection on a system with multiple screen sessions.
      screenie provides simple interactive menu to select the existing screen session or to create a new one.
    '';
    mainProgram = "screenie";
    maintainers = [ lib.maintainers.ventu06 ];
    platforms = lib.platforms.unix;
  };

})

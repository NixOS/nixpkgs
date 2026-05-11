{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  bdfresize,
  perl,
  unifont,
  dejavu_fonts,
  otf2bdf,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "console-setup";
  version = "1.242";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "installer-team";
    repo = "console-setup";
    tag = finalAttrs.version;
    hash = "sha256-5PV1Mbg7ZGQsotwnBVz8DI77Y8ULCnoTANqBLlP3YrE=";
  };

  buildInputs = [
    bdfresize
    otf2bdf
    perl
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs .
    substituteInPlace Fonts/Makefile --replace-fail '/usr/share/fonts/truetype/dejavu/' '${dejavu_fonts}/share/fonts/truetype/'
    ln -s ${unifont}/share/fonts/unifont.bdf Fonts/bdf
    substituteInPlace Fonts/Makefile --replace-fail 'rm -f $(fntdir)/bdf/unifont.bdf' ""
  '';

  preBuild = "make -j$NIX_BUILD_CORES bdf";

  installTargets = [ "install-linux" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Console font and keymap setup program";
    homepage = "https://salsa.debian.org/installer-team/console-setup";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ners ];
    mainProgram = "setupcon";
  };
})

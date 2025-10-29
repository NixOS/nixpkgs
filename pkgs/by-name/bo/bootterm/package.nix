{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bootterm";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "wtarreau";
    repo = "bootterm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AYpO2Xcd51B2qVUWoyI190BV0pIdA3HfuQJPzJ4yT/U=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "${finalAttrs.meta.mainProgram} -V";
    };
  };

  meta = {
    description = "Simple, reliable and powerful terminal to ease connection to serial ports";
    longDescription = ''
      BootTerm is a simple, reliable and powerful terminal designed to
      ease connection to ephemeral serial ports as found on various SBCs,
      and typically USB-based ones.
    '';
    homepage = "https://github.com/wtarreau/bootterm";
    license = lib.licenses.mit;
    mainProgram = "bt";
    maintainers = with lib.maintainers; [ deadbaed ];
    platforms = lib.platforms.unix;
  };
})

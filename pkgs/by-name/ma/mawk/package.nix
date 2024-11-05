{
  lib,
  buildPackages,
  directoryListingUpdater,
  fetchurl,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mawk";
  version = "1.3.4-20240819";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/mawk/mawk-${finalAttrs.version}.tgz"
      "ftp://ftp.invisible-island.net/mawk/mawk-${finalAttrs.version}.tgz"
    ];
    hash = "sha256-bh/ejuetilwVOCMWhj/WtMbSP6t4HdWrAXf/o+6arlw=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "mawk -W version";
    };
    updateScript = directoryListingUpdater {
      inherit (finalAttrs) pname version;
      url = "https://invisible-island.net/archives/mawk/";
    };
  };

  meta = {
    homepage = "https://invisible-island.net/mawk/mawk.html";
    changelog = "https://invisible-island.net/mawk/CHANGES";
    description = "Interpreter for the AWK Programming Language";
    license = lib.licenses.gpl2Only;
    mainProgram = "mawk";
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = lib.platforms.unix;
  };
})

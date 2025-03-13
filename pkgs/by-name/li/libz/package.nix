{
  lib,
  stdenv,
  fetchFromGitLab,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libz";
  version = "1.2.8.2025.03.07-unstable-2025-03-07";

  src = fetchFromGitLab {
    owner = "sortix";
    repo = "libz";
    rev = "4b22c6e013fe0ca21a7e7bc4f0661af42fb463e3";
    hash = "sha256-uumSGFBaXV6rpV4CNtnu7py7wxUUdwiFxTe7ecCgcYI=";
  };

  outputs = [
    "out"
    "dev"
  ];
  outputDoc = "dev"; # single tiny man3 page

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "libz-";
  };

  meta = {
    homepage = "https://sortix.org/libz/";
    description = "Clean fork of zlib";
    license = [ lib.licenses.zlib ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})

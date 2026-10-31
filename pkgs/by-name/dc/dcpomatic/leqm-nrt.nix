{
  stdenv,
  lib,
  fetchgit,
  wafHook,
  python3,
  gitMinimal,
  pkg-config,
  libsndfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "leqm-nrt";
  version = "0.0.2-unstable-2026-08-23";

  src = fetchgit {
    url = "https://git.carlh.net/git/leqm-nrt";
    rev = "3913040723f746c0b4a59cb55cd8a23030ea49a2";
    hash = "sha256-TzQyUeGwaWJQtWEGtS8kN7CdbKT3MMpguB9WSvztX8c=";
  };

  nativeBuildInputs = [
    wafHook
    python3
    gitMinimal
    pkg-config
  ];

  buildInputs = [
    libsndfile
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "a non-real-time implementation of Leq(M) measurement";
    homepage = "https://git.carlh.net/cgit/leqm-nrt";
    downloadPage = "https://git.carlh.net/cgit/leqm-nrt";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ logn ];
  };
})

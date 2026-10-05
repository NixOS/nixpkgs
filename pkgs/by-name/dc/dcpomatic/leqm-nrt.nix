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
  version = "0.0.2";

  src = fetchgit {
    url = "https://git.carlh.net/git/leqm-nrt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rynqxvh2FT03Fs5XOV5ZBLzB6lJlop793cMv0FB3s1g=";
  };

  patches = [
    ./leqm-nrt-libsndfile-linking.patch
  ];

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

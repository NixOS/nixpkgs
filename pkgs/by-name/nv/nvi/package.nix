{
  lib,
  stdenv,
  fetchgit,
  autoconf,
  automake,
  pkg-config,
  libtool,
  perl,
  universal-ctags,
  groff,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nvi";
  version = "1.81.6-unstable-2024-12-28";

  src = fetchgit {
    url = "https://repo.or.cz/nvi.git";
    rev = "957906b0e3bcc0f795cf8c6b7313fcc4ec338784";
    hash = "sha256-aOLP1xb54oZZFrFG/fzdTCvQFQBaxfi2X0i4Zqd2NpI=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    # This is taken from https://github.com/macports/macports-ports/tree/master/editors/nvi/files
    # patch-common_key.h.diff, patch-dist_port.h.in.diff and part of patch-includes.diff
    # Fixing issues:
    # 1. isblank clash with macOS sdk _ctypes.h
    # 2. memcpy redefined
    # 3. missing some headers
    ./darwin.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    libtool
    perl
    universal-ctags
    groff
  ];

  buildInputs = [
    ncurses
  ];

  postPatch = ''
    substituteInPlace dist/distrib \
      --replace-fail "'\`git describe\` '('\$date')" "${finalAttrs.version}"
  '';

  preConfigure = ''
    cd dist
    patchShebangs --build distrib
    ./distrib
  '';

  configureFlags = [
    "vi_cv_path_preserve=/tmp"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Berkeley Vi Editor";
    homepage = "https://repo.or.cz/nvi.git";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "vi";
    maintainers = with lib.maintainers; [ aleksana ];
  };
})

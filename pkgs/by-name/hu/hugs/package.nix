{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
}:

stdenv.mkDerivation {
  pname = "hugs98";
  version = "2006-09";

  src = fetchFromGitHub {
    owner = "augustss";
    repo = "hugs98-plus-Sep2006";
    rev = "1f7b60e05b12df00d715d535bb01c189bc1b9b3c";
    hash = "sha256-g6/4kmdWKGDIu5PXVfP8O6Fl3v4bstXWAVkoxZiS6qo=";
  };

  nativeBuildInputs = [ bison ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=implicit-int"
    "-Wno-error=implicit-function-declaration"
  ];

  postUnpack = "find -type f -exec sed -i 's@/bin/cp@cp@' {} +";

  preConfigure = "unset STRIP";

  configureFlags = [
    "--enable-char-encoding=utf8" # require that the UTF-8 encoding is always used
    "--disable-path-canonicalization"
    "--disable-timer" # evaluation timing (for benchmarking Hugs)
    "--disable-profiling" # heap profiler
    "--disable-stack-dumps" # stack dump on stack overflow
    "--enable-large-banner" # multiline startup banner
    "--disable-internal-prims" # experimental primitives to access Hugs's innards
    "--disable-debug" # include C debugging information (for debugging Hugs)
    "--disable-tag" # runtime tag checking (for debugging Hugs)
    "--disable-lint" # "lint" flags (for debugging Hugs)
    "--disable-only98" # build Hugs to understand Haskell 98 only
    "--enable-ffi"
    "--enable-pthreads" # build Hugs using POSIX threads C library
  ];

  meta = with lib; {
    mainProgram = "hugs";
    homepage = "https://www.haskell.org/hugs";
    description = "Haskell interpreter";
    maintainers = with maintainers; [ joachifm ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}

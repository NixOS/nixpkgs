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

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-int"
    "-Wno-error=implicit-function-declaration"
  ];

  postUnpack = "find -type f -exec sed -i 's@/bin/cp@cp@' {} +";

  # hsc2hs under Hugs runs a C compiler named gcc, which the Darwin stdenv
  # does not have.  The library build then skips base, unix and network,
  # and the installed Hugs has no Prelude.
  postPatch = ''
    substituteInPlace hsc2hs/Main.hs \
      --replace-fail 'default_compiler = "gcc"' 'default_compiler = "cc"'
  '';

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

  doInstallCheck = true;

  # A library package that fails to build is skipped without failing the
  # build, so load the Prelude and modules of base and unix that hsc2hs makes
  installCheckPhase = ''
    runHook preInstallCheck

    cat > check.hs <<'EOF'
    import System.CPUTime (getCPUTime)
    import System.Posix.Files (fileExist)

    main :: IO ()
    main = do
      t <- getCPUTime
      e <- fileExist "check.hs"
      print (sum [1 .. 10 :: Int], t >= 0, e)
    EOF
    [ "$($out/bin/runhugs check.hs)" = "(55,True,True)" ]

    runHook postInstallCheck
  '';

  meta = {
    mainProgram = "hugs";
    homepage = "https://www.haskell.org/hugs";
    description = "Haskell interpreter";
    maintainers = [ ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}

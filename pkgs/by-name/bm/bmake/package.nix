{
  lib,
  bc,
  fetchurl,
  getopt,
  ksh,
  pkgsMusl,
  stdenv,
  tzdata,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bmake";
  version = "20240921";

  src = fetchurl {
    url = "https://www.crufty.net/ftp/pub/sjg/bmake-${finalAttrs.version}.tar.gz";
    hash = "sha256-s0ZXnoLSltGk2ineqFlOPuWWEwsgeG3sDziZo+ESdcI=";
  };

  patches = [
    # decouple tests from build phase
    ./002-dont-test-while-installing.diff
    # preserve PATH from build env in unit tests
    ./003-fix-unexport-env-test.diff
    # Always enable ksh test since it checks in a impure location /bin/ksh
    ./004-unconditional-ksh-test.diff
  ];

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    getopt
  ];

  nativeCheckInputs = [
    bc
    tzdata
  ] ++ lib.optionals (stdenv.hostPlatform.libc != "musl") [
    ksh
  ];

  # The generated makefile is a small wrapper for calling ./boot-strap with a
  # given op. On a case-insensitive filesystem this generated makefile clobbers
  # a distinct, shipped Makefile and causes infinite recursion during tests
  # which eventually fail with "fork: Resource temporarily unavailable"
  configureFlags = [
    "--without-makefile"
  ];

  # Disabled tests:
  # * directive-export{,-gmake}: another failure related to TZ variables
  # * opt-keep-going-indirect: not yet known
  # * varmod-localtime: musl doesn't support TZDIR and this test relies on
  #   impure, implicit paths
  env.BROKEN_TESTS = builtins.concatStringsSep " " [
    "directive-export"
    "directive-export-gmake"
    "opt-keep-going-indirect"
    "varmod-localtime"
  ];

  strictDeps = true;

  doCheck = true;

  # Make tests work with musl
  # * Disable deptgt-delete_on_error test (alpine does this too)
  # * Disable shell-ksh test (ksh doesn't compile with musl)
  # * Fix test failing due to different strerror(3) output for musl and glibc
  postPatch = lib.optionalString (stdenv.hostPlatform.libc == "musl") ''
    sed -i unit-tests/Makefile \
      -e '/deptgt-delete_on_error/d' \
      -e '/shell-ksh/d'
    substituteInPlace unit-tests/opt-chdir.exp --replace "File name" "Filename"
  '';

  buildPhase = ''
    runHook preBuild

    ./boot-strap --prefix=$out -o . op=build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./boot-strap --prefix=$out -o . op=install

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    ./boot-strap -o . op=test

    runHook postCheck
  '';

  setupHook = ./setup-hook.sh;

  passthru = {
    tests = {
      bmakeMusl = pkgsMusl.bmake;
    };
  };

  meta = {
    homepage = "https://www.crufty.net/help/sjg/bmake.html";
    description = "Portable version of NetBSD 'make'";
    license = lib.licenses.bsd3;
    mainProgram = "bmake";
    maintainers = with lib.maintainers; [ thoughtpolice AndersonTorres ];
    platforms = lib.platforms.unix;
    # requires strip
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
  };
})
# TODO: report the quirks and patches to bmake devteam (especially the Musl one)
# TODO: investigate static support

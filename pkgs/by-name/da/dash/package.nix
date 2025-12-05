{
  lib,
  stdenv,
  buildPackages,
  pkg-config,
  fetchurl,
  libedit,
  runCommand,
  dash,

  # Reverse dependency smoke tests
  tests,
  patchRcPathPosix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dash";
  version = "0.5.13.1";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/dash-${finalAttrs.version}.tar.gz";
    hash = "sha256-2ScbzgnBJ9mGbiXAEVgt3HWrmIlYoEvE2FU6O48w43A=";
  };

  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isStatic [ pkg-config ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ libedit ];

  hardeningDisable = [ "strictflexarrays3" ];

  configureFlags = [ "--with-libedit" ];
  preConfigure = lib.optional stdenv.hostPlatform.isStatic ''
    export LIBS="$(''${PKG_CONFIG:-pkg-config} --libs --static libedit)"
  '';

  enableParallelBuilding = true;

  passthru = {
    shellPath = "/bin/dash";
    tests = {
      "execute-simple-command" = runCommand "dash-execute-simple-command" { } ''
        mkdir $out
        ${lib.getExe dash} -c 'echo "Hello World!" > $out/success'
        [ -s $out/success ]
        grep -q "Hello World" $out/success
      '';

      /**
        Reverse dependency smoke tests. Build success of `dash.tests` informs
        whether an update makes it into staging.
      */
      reverseDependencies = lib.recurseIntoAttrs {
        writers = lib.recurseIntoAttrs {
          simple = tests.writers.simple.dash;
          bin = tests.writers.bin.dash;
        };
        # Not sure if effective smoke test, but cheap
        patch-rc-path-posix = patchRcPathPosix.tests.test-posix;
      };
    };
  };

  meta = with lib; {
    homepage = "http://gondor.apana.org.au/~herbert/dash/";
    description = "POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
    platforms = platforms.unix;
    license = with licenses; [
      bsd3
      gpl2Plus
    ];
    mainProgram = "dash";
  };
})

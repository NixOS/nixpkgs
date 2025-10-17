{
  lib,
  stdenv,
  buildPackages,
  pkg-config,
  fetchurl,
  fetchpatch,
  libedit,
  runCommand,
  dash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dash";
  version = "0.5.13";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/dash-${finalAttrs.version}.tar.gz";
    hash = "sha256-/Y2hIeMGsn9ZMwYTQXsYK4hE8R4mlTHMRyC/Uj4+Btc=";
  };

  patches = [
    # Inverted if typo
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/utils/dash/dash.git/patch/?id=6dcc007a72f13c3e518a65bffef571795ad6678c";
      hash = "sha256-lOL/MaDHk1D/1387Exaa31mVOf3e70zRzluiFGEtUz4=";
    })
    # Missing NUL byte due to off-by-one
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/utils/dash/dash.git/patch/?id=85ae9ea3b7a9d5bc4e95d1bacf3446c545b6ed8b";
      hash = "sha256-crsE64oC/LebzggijMHBnGHSmeAy4LB57LHcL62+zBw=";
    })
  ];

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

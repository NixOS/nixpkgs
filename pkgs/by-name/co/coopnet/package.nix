{
  lib,

  stdenv,
  fetchFromGitHub,
  pkg-config,
  libjuice,

  withLogging ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "coopnet";
  version = "0-unstable-2025-11-12";

  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "coop-deluxe";
    repo = "coopnet";
    rev = "9d9b3dd4e87dba2fa3ca542ae32b73f43df32b0e";
    hash = "sha256-dWG4BZbnRyr4VDgR2pqpss6quELDN6RCwxlyBVOZxEs=";
  };

  patches = [
    # this is needed to allow nix-built packages to connect to the coopnet server
    ./hash-override.patch
  ];

  postPatch = ''
    # remove vendored libjuice
    rm -rf lib

    # upstream makefile supports a fixed number of platforms, and does not play well with cross comp and such
    rm Makefile
    ln -s ${builtins.path { path = ./Makefile; }} Makefile
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    [ ]
    ++ lib.optional withLogging "-DLOGGING"
    ++ lib.optional stdenv.hostPlatform.isDarwin "-DOSX_BUILD=1"
  );

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libjuice ];

  makeFlags = [
    "LIB_EXT=${stdenv.hostPlatform.extensions.library}"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $dev/include/coopnet
    install -T bin/client $out/bin/coopnet-client
    install -T bin/server $out/bin/coopnet-server
    install bin/lib/* -t $out/lib
    install common/libcoopnet.h -t $dev/include/coopnet

    mkdir -p $dev/lib/pkgconfig
    substitute ${builtins.path { path = ./coopnet.pc; }} $dev/lib/pkgconfig/coopnet.pc \
      --subst-var out \
      --subst-var dev \
      --subst-var pname \
      --subst-var version \
      --subst-var-by description ${lib.escapeShellArg finalAttrs.meta.description}

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    description = "Library for multiplayer sm64coopdx games";
    homepage = "https://github.com/coop-deluxe/coopnet";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.shelvacu ];
    platforms = lib.platforms.all;
  };
})

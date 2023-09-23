{ lib
, stdenv
, fetchFromGitHub

, autoreconfHook
, pandoc
, pkg-config
, openssl
, fuse3
, yajl
, libcap
, libseccomp
, python3
, which
, valgrind
, erofs-utils
, fsverity-utils
, nix-update-script

, fuseSupport ? lib.meta.availableOn stdenv.hostPlatform fuse3
, yajlSupport ? lib.meta.availableOn stdenv.hostPlatform yajl && (!stdenv.hostPlatform.isStatic)
, enableValgrindCheck ? false
, installExperimentalTools ? false
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "composefs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "composefs";
    # rev = "v${finalAttrs.version}";
    rev = "0c63ee0a5f51f6154ae6031649e8642e83f588db";
    # hash = "sha256-oXc3vpqJ4PGoHCpYnSY/kqhSHw5CVRXNreNTAg4aCSs=";
    hash = "sha256-I1YQvUjZ5dx+ioqQel4KUNzQiR4MZa5oXhGhEuInV1Q=";
  };

  strictDeps = true;
  outputs = [ "out" "lib" "dev" ];

  postPatch = ''
    echo "libcomposefs_la_LDFLAGS = -release @VERSION@" >> libcomposefs/Makefile-lib.am
  '' + lib.optionalString installExperimentalTools ''
    sed -i "s/noinst_PROGRAMS +\?=/bin_PROGRAMS +=/g" tools/Makefile.am
  '';

  configureFlags = lib.optionals enableValgrindCheck [
    (lib.enableFeature true "valgrind-test")
    # valgrind is incompatible with seccomp
    (lib.withFeatureAs true "seccomp" "no")
  ];

  nativeBuildInputs = [ autoreconfHook pandoc pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional fuseSupport fuse3
    ++ lib.optional yajlSupport yajl
    ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) (
    [
      libcap
      libseccomp
    ]
  );

  # yajl is required to read the test json files
  doCheck = yajlSupport;
  nativeCheckInputs = [ python3 which ]
    ++ lib.optional enableValgrindCheck valgrind
    ++ lib.filter (lib.meta.availableOn stdenv.buildPlatform) [ erofs-utils fsverity-utils ];

  preCheck = ''
    patchShebangs --build tests/*dir tests/*.sh
    substituteInPlace tests/*.sh \
      --replace " /tmp" " $TMPDIR" \
      --replace " /var/tmp" " $TMPDIR"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A file system for mounting container images";
    homepage = "https://github.com/containers/composefs";
    changelog = "https://github.com/containers/composefs/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus lgpl21Plus ];
    maintainers = with lib.maintainers; [ kiskae ];
    mainProgram = "mkcomposefs";
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
})

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
, testers

, fuseSupport ? lib.meta.availableOn stdenv.hostPlatform fuse3
, yajlSupport ? lib.meta.availableOn stdenv.hostPlatform yajl
, enableValgrindCheck ? false
, installExperimentalTools ? false
}:
# https://github.com/containers/composefs/issues/204
assert installExperimentalTools -> (!stdenv.hostPlatform.isMusl);
stdenv.mkDerivation (finalAttrs: {
  pname = "composefs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "composefs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OjayMhLc3otqQjHsbLN8nm9D9yGOifBcrSLixjnJmvE=";
  };

  strictDeps = true;
  outputs = [ "out" "lib" "dev" ];

  postPatch = lib.optionalString installExperimentalTools ''
    sed -i "s/noinst_PROGRAMS +\?=/bin_PROGRAMS +=/g" tools/Makefile.am
  '';

  configureFlags = lib.optionals enableValgrindCheck [
    (lib.enableFeature true "valgrind-test")
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
  doCheck = true;
  nativeCheckInputs = [ python3 which ]
    ++ lib.optional enableValgrindCheck valgrind
    ++ lib.optional fuseSupport fuse3
    ++ lib.filter (lib.meta.availableOn stdenv.buildPlatform) [ erofs-utils fsverity-utils ];

  preCheck = ''
    patchShebangs --build tests/*dir tests/*.sh
    substituteInPlace tests/*.sh \
      --replace " /tmp" " $TMPDIR" \
      --replace " /var/tmp" " $TMPDIR"
  '' + lib.optionalString (stdenv.hostPlatform.isMusl || !yajlSupport) ''
    # test relies on `composefs-from-json` tool
    # MUSL: https://github.com/containers/composefs/issues/204
    substituteInPlace tests/Makefile \
      --replace " check-checksums" ""
  '' + lib.optionalString (stdenv.hostPlatform.isMusl || enableValgrindCheck) ''
    # seccomp sandbox breaks these tests
    # MUSL: https://github.com/containers/composefs/issues/206
    substituteInPlace tests/test-checksums.sh \
      --replace "composefs-from-json" "composefs-from-json --no-sandbox"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "A file system for mounting container images";
    homepage = "https://github.com/containers/composefs";
    changelog = "https://github.com/containers/composefs/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus lgpl21Plus ];
    maintainers = with lib.maintainers; [ kiskae ];
    mainProgram = "mkcomposefs";
    pkgConfigModules = [ "composefs" ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
})

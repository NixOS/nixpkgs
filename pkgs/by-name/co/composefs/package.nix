{ lib
, stdenv
, fetchFromGitHub

, autoreconfHook
, go-md2man
, pkg-config
, openssl
, fuse3
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
, enableValgrindCheck ? false
, installExperimentalTools ? false
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "composefs";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "composefs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ViZkmuLFV5DN1nqWKGl+yaqhYUEOztZ1zGpxjr1U/dw=";
  };

  strictDeps = true;
  outputs = [ "out" "lib" "dev" ];

  postPatch = lib.optionalString installExperimentalTools ''
    sed -i "s/noinst_PROGRAMS +\?=/bin_PROGRAMS +=/g" tools/Makefile.am
  '';

  configureFlags = [
    (lib.enableFeature true "man")
    (lib.enableFeature enableValgrindCheck "valgrind-test")
  ];

  nativeBuildInputs = [ autoreconfHook go-md2man pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional fuseSupport fuse3
    ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) (
    [
      libcap
      libseccomp
    ]
  );

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

{ lib
, stdenv
, fetchFromGitHub
, fetchpatch

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
, nixosTests

, fuseSupport ? lib.meta.availableOn stdenv.hostPlatform fuse3
, enableValgrindCheck ? false
, installExperimentalTools ? false
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "composefs";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "composefs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ekUFLZGWTsiJZFv3nHoxuV057zoOtWBIkt+VdtzlaU4=";
  };

  strictDeps = true;
  outputs = [ "out" "lib" "dev" ];

  patches = [
    # fixes composefs-info tests, remove in next release
    # https://github.com/containers/composefs/pull/291
    (fetchpatch {
      url = "https://github.com/containers/composefs/commit/f7465b3a57935d96451b392b07aa3a1dafb56e7b.patch";
      hash = "sha256-OO3IfqLf3dQGjEgKx3Bo630KALmLAWwgdACuyZm2Ujc=";
    })
  ];

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
      --replace-quiet " /tmp" " $TMPDIR" \
      --replace-quiet " /var/tmp" " $TMPDIR"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      # Broken on aarch64 unrelated to this package: https://github.com/NixOS/nixpkgs/issues/291398
      inherit (nixosTests) activation-etc-overlay-immutable activation-etc-overlay-mutable;
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "File system for mounting container images";
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

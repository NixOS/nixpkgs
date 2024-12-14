{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  go-md2man,
  pkg-config,
  openssl,
  fuse3,
  libcap,
  python3,
  which,
  valgrind,
  erofs-utils,
  fsverity-utils,
  nix-update-script,
  testers,
  nixosTests,

  fuseSupport ? lib.meta.availableOn stdenv.hostPlatform fuse3,
  enableValgrindCheck ? false,
  installExperimentalTools ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "composefs";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "composefs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kbXmDdyRrtsERkUomjZUWP3QC2q27AWUTc/J2jCSXg4=";
  };

  strictDeps = true;
  outputs = [
    "out"
    "lib"
    "dev"
  ];

  postPatch =
    # 'both_libraries' as an install target always builds both versions.
    #  This results in double disk usage for normal builds and broken static builds,
    #  so we replace it with the regular library target.
    ''
      substituteInPlace libcomposefs/meson.build \
        --replace-fail "both_libraries" "library"
    ''
    + lib.optionalString installExperimentalTools ''
      substituteInPlace tools/meson.build \
        --replace-fail "install : false" "install : true"
    '';

  nativeBuildInputs = [
    meson
    ninja
    go-md2man
    pkg-config
  ];
  buildInputs =
    [ openssl ]
    ++ lib.optional fuseSupport fuse3
    ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) ([
      libcap
    ]);

  doCheck = true;
  nativeCheckInputs =
    [
      python3
      which
    ]
    ++ lib.optional enableValgrindCheck valgrind
    ++ lib.optional fuseSupport fuse3
    ++ lib.filter (lib.meta.availableOn stdenv.buildPlatform) [
      erofs-utils
      fsverity-utils
    ];

  mesonCheckFlags = lib.optionals enableValgrindCheck "--setup=valgrind";

  preCheck = ''
    patchShebangs --build ../tests/*dir ../tests/*.sh
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
    license = with lib.licenses; [
      gpl2Only
      asl20
    ];
    maintainers = with lib.maintainers; [ kiskae ];
    mainProgram = "mkcomposefs";
    pkgConfigModules = [ "composefs" ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
})

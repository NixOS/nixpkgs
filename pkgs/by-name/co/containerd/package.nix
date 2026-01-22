{
  lib,
  stdenv,
  pkgsCross,
  btrfs-progs,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch2,
  go-md2man,
  kubernetes,
  nix-update-script,
  nixosTests,
  util-linux,
  btrfsSupport ? btrfs-progs != null,
  withMan ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

buildGoModule rec {
  pname = "containerd";
  version = "2.2.1";

  outputs = [
    "out"
    "doc"
  ]
  ++ lib.optional withMan "man";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    tag = "v${version}";
    hash = "sha256-fDOfN0XESrBTDW7Nxj9niqU93BQ5/JaGLwAR3u6Xaik=";
  };

  patches = [
    # fix(oci): handle absolute symlinks in rootfs user lookup
    # https://github.com/containerd/containerd/pull/12732
    (fetchpatch2 {
      # PR #12732 commit 85b5418… (the actual fix)
      url = "https://github.com/containerd/containerd/commit/85b5418ef5a6adeac95c910bf8c33ae0fb7bbecb.patch";
      hash = "sha256-M6kxUbf8JECta8pfFlvZ7F51ZS4aK9IEkwy7kbfdHM0=";
    })

    (fetchpatch2 {
      # PR #12732 commit 9bbb130… (tests / coverage)
      url = "https://github.com/containerd/containerd/commit/9bbb1309f051e54b51484fa0efbfe93e26223a2d.patch";
      hash = "sha256-QK+WGJRjJxro26MF04yGYcfAtNvoAZqAUYg8UzEOVqM=";
    })
  ];

  postPatch = ''
    patchShebangs .
  ''
  + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # When cross-compiling with CGO_ENABLED=0, we can't use -extldflags "-static"
    # Remove it from SHIM_GO_LDFLAGS to avoid linking errors
    substituteInPlace Makefile \
      --replace-fail '-extldflags "-static"' ""
  '';

  vendorHash = null;

  strictDeps = true;

  nativeBuildInputs = [
    util-linux
  ]
  ++ lib.optional withMan go-md2man;

  buildInputs = lib.optional btrfsSupport btrfs-progs;

  tags = lib.optional (!btrfsSupport) "no_btrfs";

  makeFlags = [
    "PREFIX=${placeholder "out"}"

    "BUILDTAGS=${toString tags}"
    "REVISION=${src.rev}"
    "VERSION=v${version}"
  ];

  installTargets = [
    "install"
    "install-doc"
  ]
  ++ lib.optional withMan "install-man";

  buildPhase = ''
    runHook preBuild
    make $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make $makeFlags $installTargets
    runHook postInstall
  '';

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux (
      {
        cross =
          let
            systemString = if stdenv.buildPlatform.isAarch64 then "gnu64" else "aarch64-multiplatform";
          in
          pkgsCross.${systemString}.containerd;

        inherit (nixosTests) docker;
      }
      // kubernetes.tests
    );

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Daemon to control runC";
    homepage = "https://containerd.io/";
    changelog = "https://github.com/containerd/containerd/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      offline
      vdemeester
      getchoo
    ];
    mainProgram = "containerd";
    platforms = lib.platforms.linux;
  };
}

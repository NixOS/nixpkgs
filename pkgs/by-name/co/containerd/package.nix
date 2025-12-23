{
  lib,
  stdenv,
  pkgsCross,
  btrfs-progs,
  buildGoModule,
  fetchFromGitHub,
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
  version = "2.2.0";

  outputs = [
    "out"
    "doc"
  ]
  ++ lib.optional withMan "man";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    tag = "v${version}";
    hash = "sha256-LXBGA03FTrrbxlH+DxPBFtp3/AYQf096YE2rpe6A+WM=";
  };

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

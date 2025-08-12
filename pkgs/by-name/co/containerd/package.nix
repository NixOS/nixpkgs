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
  version = "2.1.4";

  outputs = [
    "out"
    "doc"
  ]
  ++ lib.optional withMan "man";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    tag = "v${version}";
    hash = "sha256-eC9mfB/FWDxOGucNizHBiRkhkEFDdSxu9vRnXZp5Tug=";
  };

  postPatch = "patchShebangs .";

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

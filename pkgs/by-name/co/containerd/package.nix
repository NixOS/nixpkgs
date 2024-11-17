{
  lib,
  btrfs-progs,
  buildGoModule,
  fetchFromGitHub,
  go-md2man,
  kubernetes,
  nixosTests,
  util-linux,
}:

buildGoModule rec {
  pname = "containerd";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "refs/tags/v${version}";
    hash = "sha256-DFAP+zjBYP2SpyD8KXGvI3i/PUZ6d4jdzGyFfr1lzj4=";
  };

  postPatch = "patchShebangs .";

  vendorHash = null;

  strictDeps = true;

  nativeBuildInputs = [
    go-md2man
    util-linux
  ];

  buildInputs = [ btrfs-progs ];

  tags = lib.optionals (btrfs-progs == null) [ "no_btrfs" ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"

    "BUILDTAGS=${toString tags}"
    "REVISION=${src.rev}"
    "VERSION=v${version}"
  ];

  installTargets = [
    "install"
    "install-doc"
    "install-man"
  ];

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

  passthru.tests = {
    inherit (nixosTests) docker;
  } // kubernetes.tests;

  meta = {
    description = "Daemon to control runC";
    homepage = "https://containerd.io/";
    changelog = "https://github.com/containerd/containerd/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      offline
      vdemeester
    ];
    platforms = lib.platforms.linux;
  };
}

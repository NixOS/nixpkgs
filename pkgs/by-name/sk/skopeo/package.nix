{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gpgme,
  lvm2,
  btrfs-progs,
  pkg-config,
  go-md2man,
  installShellFiles,
  makeWrapper,
  fuse-overlayfs,
  dockerTools,
  runCommand,
  testers,
  skopeo,
}:

buildGoModule rec {
  pname = "skopeo";
  version = "1.20.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
    hash = "sha256-uw41kaIljz9Y378rX2BK0W/ZVUx8IjlIBqYHDuLgZpA=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = null;

  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    go-md2man
    installShellFiles
    makeWrapper
  ];

  buildInputs = [
    gpgme
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    lvm2
    btrfs-progs
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make bin/skopeo docs
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    make completions
  ''
  + ''
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    PREFIX=${placeholder "out"} make install-binary install-docs
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    PREFIX=${placeholder "out"} make install-completions
  ''
  + ''
    install ${passthru.policy}/default-policy.json -Dt $out/etc/containers
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/skopeo \
      --prefix PATH : ${lib.makeBinPath [ fuse-overlayfs ]}
  ''
  + ''
    runHook postInstall
  '';

  passthru = {
    policy = runCommand "policy" { } ''
      install ${src}/default-policy.json -Dt $out
    '';
    tests = {
      version = testers.testVersion {
        package = skopeo;
      };
      inherit (dockerTools.examples) testNixFromDockerHub;
    };
  };

  meta = with lib; {
    changelog = "https://github.com/containers/skopeo/releases/tag/${src.rev}";
    description = "Command line utility for various operations on container images and image repositories";
    mainProgram = "skopeo";
    homepage = "https://github.com/containers/skopeo";
    maintainers = with maintainers; [
      lewo
      developer-guy
      ryan4yin
    ];
    teams = [ teams.podman ];
    license = licenses.asl20;
  };
}

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
<<<<<<< HEAD
  version = "1.21.0";
=======
  version = "1.20.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
<<<<<<< HEAD
    hash = "sha256-wL+++p89nZZA5gG6LIDjXIDvHxfGy/sKYNiTR0A38Ew=";
=======
    hash = "sha256-uw41kaIljz9Y378rX2BK0W/ZVUx8IjlIBqYHDuLgZpA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/containers/skopeo/releases/tag/${src.rev}";
    description = "Command line utility for various operations on container images and image repositories";
    mainProgram = "skopeo";
    homepage = "https://github.com/containers/skopeo";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
=======
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lewo
      developer-guy
      ryan4yin
    ];
<<<<<<< HEAD
    teams = [ lib.teams.podman ];
    license = lib.licenses.asl20;
=======
    teams = [ teams.podman ];
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

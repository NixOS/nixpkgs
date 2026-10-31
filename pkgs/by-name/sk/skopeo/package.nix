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
  makeBinaryWrapper,
  fuse-overlayfs,
  dockerTools,
  runCommand,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "skopeo";
  version = "1.24.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "podman-container-tools";
    repo = "skopeo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jLKbo6+xgHaMkMimbGIni5iZcVyeMF8wHTI594UkHQI=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = null;

  nativeBuildInputs = [
    pkg-config
    go-md2man
    makeBinaryWrapper
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
    install -m644 ${finalAttrs.passthru.policy}/default-policy.json -Dt $out/etc/containers
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/skopeo \
      --prefix PATH : ${lib.makeBinPath [ fuse-overlayfs ]}
  ''
  + ''
    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    make test-unit-local
    runHook postCheck
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    policy = runCommand "policy" { } ''
      install -m644 ${finalAttrs.src}/default-policy.json -Dt $out
    '';
    tests = {
      testNixFromDockerHub =
        (dockerTools.override {
          skopeo = finalAttrs.finalPackage;
        }).examples.testNixFromDockerHub;
    };
  };

  meta = {
    changelog = "https://github.com/podman-container-tools/skopeo/releases/tag/${finalAttrs.src.tag}";
    description = "Command line utility for various operations on container images and image repositories";
    mainProgram = "skopeo";
    homepage = "https://github.com/podman-container-tools/skopeo";
    maintainers = with lib.maintainers; [
      lewo
      developer-guy
      ryan4yin
    ];
    teams = [ lib.teams.podman ];
    license = lib.licenses.asl20;
  };
})

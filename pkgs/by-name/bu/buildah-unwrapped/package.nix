{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  go-md2man,
  installShellFiles,
  pkg-config,
  gpgme,
  lvm2,
  btrfs-progs,
  libapparmor,
  libselinux,
  libseccomp,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "buildah";
  version = "1.42.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "buildah";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YWyA2wTIlJNwuqcPHOBFZ2wr46Z0I83FWRew/FC3Wxs=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = null;

  doCheck = false;

  nativeBuildInputs = [
    go-md2man
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    gpgme
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    btrfs-progs
    libapparmor
    libseccomp
    libselinux
    lvm2
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make bin/buildah
    make -C docs GOMD2MAN="go-md2man"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/buildah $out/bin/buildah
    installShellCompletion --bash contrib/completions/bash/buildah
    make -C docs install PREFIX="$man"
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "Tool which facilitates building OCI images";
    mainProgram = "buildah";
    homepage = "https://buildah.io/";
    changelog = "https://github.com/containers/buildah/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
  };
})

{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go-md2man,
  installShellFiles,
  pkg-config,
  which,
  libapparmor,
  libseccomp,
  libselinux,
  stdenv,
  makeBinaryWrapper,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "runc";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yva0zrcnuHCuIYVi07sxTxNc4fOXVo93jO1hbHjdYNo=";
  };

  vendorHash = null;
  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    go-md2man
    installShellFiles
    makeBinaryWrapper
    pkg-config
    which
  ];

  buildInputs = [
    libselinux
    libseccomp
    libapparmor
  ];

  makeFlags = [
    "BUILDTAGS+=seccomp"
    "SHELL=${stdenv.shell}"
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make ${toString finalAttrs.makeFlags} runc man
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 runc $out/bin/runc
    installManPage man/*/*.[1-9]
    wrapProgram $out/bin/runc \
      --prefix PATH : /run/current-system/systemd/bin
    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) cri-o docker podman; };

  meta = with lib; {
    homepage = "https://github.com/opencontainers/runc";
    description = "CLI tool for spawning and running containers according to the OCI specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    teams = [ teams.podman ];
    platforms = platforms.linux;
    mainProgram = "runc";
  };
})

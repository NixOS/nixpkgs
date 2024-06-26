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
  makeWrapper,
  nixosTests,
}:

buildGoModule rec {
  pname = "runc";
  version = "1.1.13";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    rev = "v${version}";
    hash = "sha256-RQsM8Q7HogDVGbNpen3wxXNGR9lfqmNhkXTRoC+LBk8=";
  };

  vendorHash = null;
  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    go-md2man
    installShellFiles
    makeWrapper
    pkg-config
    which
  ];

  buildInputs = [
    libselinux
    libseccomp
    libapparmor
  ];

  makeFlags = [ "BUILDTAGS+=seccomp" ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make ${toString makeFlags} runc man
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

  passthru.tests = {
    inherit (nixosTests) cri-o docker podman;
  };

  meta = with lib; {
    homepage = "https://github.com/opencontainers/runc";
    description = "CLI tool for spawning and running containers according to the OCI specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ] ++ teams.podman.members;
    platforms = platforms.linux;
    mainProgram = "runc";
  };
}

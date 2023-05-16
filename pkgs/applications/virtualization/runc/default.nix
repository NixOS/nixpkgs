{ lib
, fetchFromGitHub
, buildGoModule
, go-md2man
, installShellFiles
, pkg-config
, which
, libapparmor
, libseccomp
, libselinux
, makeWrapper
, procps
, nixosTests
}:

buildGoModule rec {
  pname = "runc";
<<<<<<< HEAD
  version = "1.1.9";
=======
  version = "1.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-9vNzKoG+0Ze4+dhluNM6QtsUjV8/bpkuvEF8ASBfBRo=";
=======
    hash = "sha256-reSC9j9ESjRigItBRytef78XBjmMGsqu0o9qcN2AstU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;
  outputs = [ "out" "man" ];

  nativeBuildInputs = [ go-md2man installShellFiles makeWrapper pkg-config which ];

  buildInputs = [ libselinux libseccomp libapparmor ];

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
      --prefix PATH : ${lib.makeBinPath [ procps ]} \
      --prefix PATH : /run/current-system/systemd/bin
    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) cri-o docker podman; };

  meta = with lib; {
    homepage = "https://github.com/opencontainers/runc";
    description = "A CLI tool for spawning and running containers according to the OCI specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}

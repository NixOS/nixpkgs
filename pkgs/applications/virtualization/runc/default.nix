{ lib
, fetchFromGitHub
, buildGoPackage
, go-md2man
, installShellFiles
, pkg-config
, which
, libapparmor
, apparmor-parser
, libseccomp
, libselinux
, nixosTests
}:

buildGoPackage rec {
  pname = "runc";
  version = "1.0.0-rc91";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    rev = "v${version}";
    sha256 = "1hg3hbbjsz76q1piz86q8la6dym86d65xd7h6q12krfmwd2lbhkw";
  };

  goPackagePath = "github.com/opencontainers/runc";
  outputs = [ "out" "man" ];

  nativeBuildInputs = [ go-md2man installShellFiles pkg-config which ];

  buildInputs = [ libselinux libseccomp libapparmor apparmor-parser ];

  makeFlags = [ "BUILDTAGS+=seccomp" "BUILDTAGS+=apparmor" "BUILDTAGS+=selinux" ];

  buildPhase = ''
    cd go/src/${goPackagePath}
    patchShebangs .
    substituteInPlace libcontainer/apparmor/apparmor.go \
      --replace /sbin/apparmor_parser ${apparmor-parser}/bin/apparmor_parser
    make ${toString makeFlags} runc man
  '';

  installPhase = ''
    install -Dm755 runc $out/bin/runc
    installManPage man/*/*.[1-9]
  '';

  passthru.tests.podman = nixosTests.podman;

  meta = with lib; {
    homepage = "https://github.com/opencontainers/runc";
    description = "A CLI tool for spawning and running containers according to the OCI specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}

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
}:

buildGoPackage rec {
  pname = "runc";
  version = "1.0.0-rc10";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    rev = "v${version}";
    sha256 = "0pi3rvj585997m4z9ljkxz2z9yxf9p2jr0pmqbqrc7bc95f5hagk";
  };

  goPackagePath = "github.com/opencontainers/runc";
  outputs = [ "bin" "out" "man" ];

  hardeningDisable = [ "fortify" ];

  nativeBuildInputs = [ go-md2man installShellFiles pkg-config which ];
  buildInputs = [ libseccomp libapparmor apparmor-parser ];

  makeFlags = [ "BUILDTAGS+=seccomp" "BUILDTAGS+=apparmor" ];

  buildPhase = ''
    cd go/src/${goPackagePath}
    patchShebangs .
    substituteInPlace libcontainer/apparmor/apparmor.go \
      --replace /sbin/apparmor_parser ${apparmor-parser}/bin/apparmor_parser
    make ${toString makeFlags} runc man
  '';

  installPhase = ''
    install -Dm755 runc $bin/bin/runc
    installManPage man/*/*
  '';

  meta = with lib; {
    homepage = "https://github.com/opencontainers/runc";
    description = "A CLI tool for spawning and running containers according to the OCI specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}

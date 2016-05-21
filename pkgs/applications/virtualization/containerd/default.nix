{ stdenv, fetchFromGitHub
, go, libapparmor, apparmor-parser, libseccomp }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "containerd-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "07axhrvy45zwnsrvr2618227bzrnqdcjdl7j0mnrhvlryypiic0l";
  };

  buildInputs = [ go libapparmor libseccomp ];

  makeFlags = ''BUILDTAGS+=seccomp BUILDTAGS+=apparmor'';

  preBuild = ''
    ln -s $(pwd) vendor/src/github.com/docker/containerd
    substituteInPlace vendor/src/github.com/opencontainers/runc/libcontainer/apparmor/apparmor.go \
        --replace /sbin/apparmor_parser ${apparmor-parser}/bin/apparmor_parser
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://containerd.tools/;
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}

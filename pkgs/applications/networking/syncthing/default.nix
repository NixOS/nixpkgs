{ stdenv, fetchgit, go }:

stdenv.mkDerivation rec {
  version = "0.13.4";
  name = "syncthing-${version}";

  src = fetchgit {
    url = https://github.com/syncthing/syncthing;
    rev = "refs/tags/v${version}";
    sha256 = "0aa0nqi0gmka5r5dzph4g51jlsy7w5q4ri8f4gy3qnma4pgp7pg2";
  };

  buildInputs = [ go ];

  buildPhase = ''
    mkdir -p src/github.com/syncthing
    ln -s $(pwd) src/github.com/syncthing/syncthing
    export GOPATH=$(pwd)
    # Required for Go 1.5, can be removed for Go 1.6+
    export GO15VENDOREXPERIMENT=1

    # Syncthing's build.go script expects this working directory
    cd src/github.com/syncthing/syncthing

    go run build.go -no-upgrade -version v${version} install all
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';

  meta = {
    homepage = https://www.syncthing.net/;
    description = "Open Source Continuous File Synchronization";
    license = stdenv.lib.licenses.mpl20;
    maintainers = with stdenv.lib.maintainers; [pshendry];
    platforms = with stdenv.lib.platforms; linux ++ freebsd ++ openbsd ++ netbsd;
  };
}

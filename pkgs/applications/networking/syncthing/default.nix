{ stdenv, fetchgit, go }:

stdenv.mkDerivation rec {
  version = "0.13.10";
  name = "syncthing-${version}";

  src = fetchgit {
    url = https://github.com/syncthing/syncthing;
    rev = "refs/tags/v${version}";
    sha256 = "07q3j6mnrza719rnvbkdsmvlkyr2pch5sj2l204m5iy5mxaghpx7";
  };

  buildInputs = [ go ];

  buildPhase = ''
    mkdir -p src/github.com/syncthing
    ln -s $(pwd) src/github.com/syncthing/syncthing
    export GOPATH=$(pwd)

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

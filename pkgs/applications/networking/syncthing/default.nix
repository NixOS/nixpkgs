{ stdenv, fetchgit, go }:

stdenv.mkDerivation rec {
  version = "0.14.0";
  name = "syncthing-${version}";

  src = fetchgit {
    url = https://github.com/syncthing/syncthing;
    rev = "refs/tags/v${version}";
    sha256 = "15l3q3r6i3q95i474winswx4y149b5ic7xhpnj52s78fxd4va2q2";
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

{ stdenv, fetchgit, go }:

stdenv.mkDerivation rec {
  version = "0.13.9";
  name = "syncthing-${version}";

  src = fetchgit {
    url = https://github.com/syncthing/syncthing;
    rev = "refs/tags/v${version}";
    sha256 = "1ah3a86rjfqlx4mqyvn8j3r806i65mzhs5xnfg4aakzmwpr5zpx0";
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

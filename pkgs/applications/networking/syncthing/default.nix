{ stdenv, fetchFromGitHub, go }:

stdenv.mkDerivation rec {
  version = "0.14.3";
  name = "syncthing-${version}";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing";
    rev = "v${version}";
    sha256 = "114i0911h3q6dn3j9x2qcm5lzpqclvrpf5vk87qpqp9qy62jp3az";
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
    maintainers = with stdenv.lib.maintainers; [ pshendry joko peterhoeg ];
    platforms = with stdenv.lib.platforms; linux ++ freebsd ++ openbsd ++ netbsd;
  };
}

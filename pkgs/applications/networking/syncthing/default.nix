{ stdenv, fetchFromGitHub, go }:

stdenv.mkDerivation rec {
  version = "0.14.2";
  name = "syncthing-${version}";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing";
    rev = "v${version}";
    sha256 = "0is4f1r3im2bbmbca9fafzxffikxaf86vd6f851831fk5wi4pzw9";
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
    maintainers = with stdenv.lib.maintainers; [ pshendry joko ];
    platforms = with stdenv.lib.platforms; linux ++ freebsd ++ openbsd ++ netbsd;
  };
}

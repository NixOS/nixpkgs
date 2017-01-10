{ stdenv, lib, fetchFromGitHub, go, pkgs }:

stdenv.mkDerivation rec {
  version = "0.14.18";
  name = "syncthing-${version}";

  src = fetchFromGitHub {
    owner  = "syncthing";
    repo   = "syncthing";
    rev    = "v${version}";
    sha256 = "099r1n9awznv17ac1fm4ff6az40bvk6xxwaw8x8fx7ikqi1wv8vp";
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
    mkdir -p $out/bin $out/etc/systemd/{system,user}

    cp bin/* $out/bin
  '' + lib.optionalString (stdenv.isLinux) ''
    substitute etc/linux-systemd/system/syncthing-resume.service \
               $out/etc/systemd/system/syncthing-resume.service \
               --replace /usr/bin/pkill ${pkgs.procps}/bin/pkill

    substitute etc/linux-systemd/system/syncthing@.service \
               $out/etc/systemd/system/syncthing@.service \
               --replace /usr/bin/syncthing $out/bin/syncthing

    substitute etc/linux-systemd/user/syncthing.service \
               $out/etc/systemd/user/syncthing.service \
               --replace /usr/bin/syncthing $out/bin/syncthing
  '';

  meta = with stdenv.lib; {
    homepage = https://www.syncthing.net/;
    description = "Open Source Continuous File Synchronization";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pshendry joko peterhoeg ];
    platforms = platforms.unix;
  };
}

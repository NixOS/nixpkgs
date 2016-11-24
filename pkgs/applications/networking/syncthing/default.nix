{ stdenv, lib, fetchFromGitHub, go, pkgs }:

stdenv.mkDerivation rec {
  version = "0.14.12";
  name = "syncthing-${version}";

  src = fetchFromGitHub {
    owner  = "syncthing";
    repo   = "syncthing";
    rev    = "v${version}";
    sha256 = "09w0i9rmdi9fjsphib2x6gs6yn5d1a41nh1pm4k9ks31am9zdwsm";
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
    license = stdenv.lib.licenses.mpl20;
    maintainers = with stdenv.lib.maintainers; [ pshendry joko peterhoeg ];
    platforms = stdenv.lib.platforms.unix;
  };
}

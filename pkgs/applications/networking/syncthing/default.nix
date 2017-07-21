{ stdenv, lib, fetchFromGitHub, go, procps, removeReferencesTo }:

stdenv.mkDerivation rec {
  version = "0.14.32";
  name = "syncthing-${version}";

  src = fetchFromGitHub {
    owner  = "syncthing";
    repo   = "syncthing";
    rev    = "v${version}";
    sha256 = "1agjr3m4gnywbp40idi0pwy25cp836sdcar7r6r9hwcqxyyzz545";
  };

  buildInputs = [ go removeReferencesTo ];

  buildPhase = ''
    mkdir -p src/github.com/syncthing
    ln -s $(pwd) src/github.com/syncthing/syncthing
    export GOPATH=$(pwd)

    # Syncthing's build.go script expects this working directory
    cd src/github.com/syncthing/syncthing

    go run build.go -no-upgrade -version v${version} install all
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/systemd/{system,user}

    cp bin/* $out/bin
  '' + lib.optionalString (stdenv.isLinux) ''
    substitute etc/linux-systemd/system/syncthing-resume.service \
               $out/lib/systemd/system/syncthing-resume.service \
               --replace /usr/bin/pkill ${procps}/bin/pkill

    substitute etc/linux-systemd/system/syncthing@.service \
               $out/lib/systemd/system/syncthing@.service \
               --replace /usr/bin/syncthing $out/bin/syncthing

    substitute etc/linux-systemd/user/syncthing.service \
               $out/lib/systemd/user/syncthing.service \
               --replace /usr/bin/syncthing $out/bin/syncthing
  '';

  preFixup = ''
    find $out/bin -type f -exec remove-references-to -t ${go} '{}' '+'
  '';

  meta = with stdenv.lib; {
    homepage = https://www.syncthing.net/;
    description = "Open Source Continuous File Synchronization";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pshendry joko peterhoeg ];
    platforms = platforms.unix;
  };
}

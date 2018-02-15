{ pkgs }:

let
  inherit (pkgs) lib fetchFromGitHub go removeReferencesTo;

in rec {
  version = "0.14.44";
  src = fetchFromGitHub {
    owner  = "syncthing";
    repo   = "syncthing";
    rev    = "v${version}";
    sha256 = "1gdkx6lbzmdz2hqc9slbq41rwgkxmdisnj0iywx4mppmc2b4v6wh";
  };

  buildInputs = [ go removeReferencesTo ];

  preFixup = ''
    find $out/bin -type f -exec remove-references-to -t ${go} '{}' '+'
  '';

  meta = with lib; {
    homepage = https://www.syncthing.net/;
    description = "Open Source Continuous File Synchronization";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pshendry joko peterhoeg ];
    platforms = platforms.unix;
  };

  makeBuildPhase = target: ''
    # Syncthing expects that it is checked out in $GOPATH, if that variable is
    # set.  Since this isn't true when we're fetching source, we can explicitly
    # unset it and force Syncthing to set up a temporary one for us.
    env GOPATH= go run build.go -no-upgrade -version v${version} build ${target}
  '';
}

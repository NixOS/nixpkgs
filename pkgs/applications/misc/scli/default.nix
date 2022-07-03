{ lib
, python3
, fetchFromGitHub
, dbus
, signal-cli
, xclip
}:

python3.pkgs.buildPythonApplication rec {
  pname = "scli";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "isamert";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YEgeeoUqDeBx3jPddTeykl+68lS8gVKD+zdo+gRTaT4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pyqrcode
    urwid
    urwid-readline
  ];

  dontBuild = true;

  checkPhase = ''
    # scli attempts to write to these directories, make sure they're writeable
    export XDG_DATA_HOME=$(mktemp -d)
    export XDG_CONFIG_HOME=$(mktemp -d)
    ./scli --help > /dev/null # don't spam nix-build log
    test $? == 0
  '';

  installPhase = ''
    mkdir -p $out/bin
    patchShebangs scli
    install -m755 -D scli $out/bin/scli
  '';

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ dbus signal-cli xclip ])
  ];

  meta = with lib; {
    description = "Simple terminal user interface for Signal";
    homepage = "https://github.com/isamert/scli";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexeyre ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,

  dbus,
  libGL,
  libX11,
  libXcursor,
  libXinerama,
  libXi,
  libXrandr,
  libXxf86vm,
  pkg-config,
}:

buildGoModule rec {
  pname = "fyne";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "fyne";
    rev = "v${version}";
    hash = "sha256-6gDHURcf4dVmaiXleeRKogAtCAgcHU437TjEHhfGdj8=";
  };

  vendorHash = "sha256-0P2YqXq+c20F2hVkRcvwV5PpqUoZ3PnRIvTHt/qAMPA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libGL
    libX11
    libXcursor
    libXinerama
    libXi
    libXrandr
    libXxf86vm
  ];

  checkInputs = [
    dbus
  ];

  doCheck = true;

  preCheck = ''
    OLD_DIR=$PWD
    export HOME=$(mktemp -d)
    cd $HOME
  '';

  preInstall = ''
    if [ -n "$OLD_DIR" ]; then cd "$OLD_DIR"; fi
  '';

  meta = with lib; {
    homepage = "https://fyne.io";
    description = "A GUI library and tools for golang";
    license = licenses.bsd3;
    maintainers = [ maintainers.greg ];
    mainProgram = "fyne";
  };
}

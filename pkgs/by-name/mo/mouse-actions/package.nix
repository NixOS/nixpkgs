{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, libX11
, libXi
, libXtst
, libevdev
}:

rustPlatform.buildRustPackage rec {
  pname = "mouse-actions";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "jersou";
    repo = "mouse-actions";
    rev = "v${version}";
    hash = "sha256-02E4HrKIoBV3qZPVH6Tjz9Bv/mh5C8amO1Ilmd+YO5g=";
  };

  cargoHash = "sha256-5SUVZlrXIPtlu9KBzucZDCp5t5t8Z4/Nfht2Pw5agVI=";

  buildInputs = [
    libX11
    libXi
    libXtst
    libevdev
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d/
    echo 'KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"' >> $out/etc/udev/rules.d/80-mouse-actions.rules
    echo 'KERNEL=="/dev/input/event*", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"' >> $out/etc/udev/rules.d/80-mouse-actions.rules
  '';

  meta = with lib; {
    description = "Execute commands from mouse events such as clicks/wheel on the side/corners of the screen, or drawing shapes";
    homepage = "https://github.com/jersou/mouse-actions";
    license = licenses.mit;
    maintainers = with maintainers; [ rgri ];
    mainProgram = "mouse-actions";
    platforms = platforms.linux;
  };
}

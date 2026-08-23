{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libx11,
  libxi,
  libxtst,
  libevdev,
  udevCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mouse-actions";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "jersou";
    repo = "mouse-actions";
    rev = "v${finalAttrs.version}";
    hash = "sha256-44F4CdsDHuN2FuijnpfmoFy4a/eAbYOoBYijl9mOctg=";
  };

  cargoHash = "sha256-3ylJSb6ItIkOl5Unhnm5aL83mQvWIM0PUg+1lMtUbPY=";

  doInstallCheck = true;

  buildInputs = [
    libx11
    libxi
    libxtst
    libevdev
  ];

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d/
    echo 'KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"' >> $out/etc/udev/rules.d/80-mouse-actions.rules
    echo 'KERNEL=="/dev/input/event*", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"' >> $out/etc/udev/rules.d/80-mouse-actions.rules
  '';

  meta = {
    description = "Execute commands from mouse events such as clicks/wheel on the side/corners of the screen, or drawing shapes";
    homepage = "https://github.com/jersou/mouse-actions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rgri ];
    mainProgram = "mouse-actions";
    platforms = lib.platforms.linux;
  };
})

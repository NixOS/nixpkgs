{
  autoreconfHook,
  fetchFromGitLab,
  lib,
  libusb1,
  nix-update-script,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libjaylink";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.zapb.de";
    owner = "libjaylink";
    repo = "libjaylink";
    tag = version;
    hash = "sha256-PghPVgovNo/HhNg7c6EGXrqi6jMrb8p/uLqGDIZ7t+s=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libusb1 ];

  postPatch = ''
    patchShebangs autogen.sh
  '';

  postInstall = ''
    install -Dm644 contrib/60-libjaylink.rules $out/lib/udev/rules.d/60-libjaylink.rules
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://gitlab.zapb.de/libjaylink/libjaylink";
    description = "libjaylink is a shared library written in C to access SEGGER J-Link and compatible devices";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.unix;
  };
}

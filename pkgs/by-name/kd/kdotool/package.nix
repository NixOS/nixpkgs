{
  lib,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.2.2";
  pname = "kdotool";

  src = fetchFromGitHub {
    owner = "jinliu";
    repo = "kdotool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aJRqFcKyu4/aqI3WtH9NjzjNgiI6lq0VgCXNGaNdyvE=";
  };

  cargoHash = "sha256-QrJVN2O/pDCIpD1ioFPZyj7au3DQtU3l/I440WsyYWo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = {
    description = "xdotool clone for KDE Wayland";
    homepage = "https://github.com/jinliu/kdotool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kotatsuyaki ];
  };
})

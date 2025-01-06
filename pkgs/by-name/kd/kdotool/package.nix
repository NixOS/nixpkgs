{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  version = "0.2.1";
  pname = "kdotool";

  src = fetchFromGitHub {
    owner = "jinliu";
    repo = "kdotool";
    rev = "v${version}";
    hash = "sha256-ogdZziNV4b3h9LiEyWFrD/I/I4k8Z5rNFTNjQpWBQtg=";
  };

  cargoHash = "sha256-pL5vLfNWsZi75mI5K/PYVmgHTPCyIKpQY0YU2CJABN8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = {
    description = "xdotool-like for KDE Wayland";
    homepage = "https://github.com/jinliu/kdotool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kotatsuyaki ];
  };
}

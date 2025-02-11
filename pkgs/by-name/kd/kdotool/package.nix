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

  useFetchCargoVendor = true;
  cargoHash = "sha256-eA74jvXVPtiE6K+OMJg99wM2q0DwxSHVJ5YZ9h37b/A=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "xdotool-like for KDE Wayland";
    homepage = "https://github.com/jinliu/kdotool";
    license = licenses.asl20;
    maintainers = with maintainers; [ kotatsuyaki ];
  };
}

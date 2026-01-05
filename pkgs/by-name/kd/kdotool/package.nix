{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  version = "0.2.2-pre";
  pname = "kdotool";

  src = fetchFromGitHub {
    owner = "jinliu";
    repo = "kdotool";
    rev = "v${version}";
    hash = "sha256-qx4bWAFQcoLM/r4aNzmoZdjclw8ccAW8lKLda6ON1aQ=";
  };

  cargoHash = "sha256-ASR2zMwVCKeEZPYQNoO54J00eZyTn1i6FE0NBCJWSCs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "xdotool clone for KDE Wayland";
    homepage = "https://github.com/jinliu/kdotool";
    license = licenses.asl20;
    maintainers = with maintainers; [ kotatsuyaki ];
  };
}

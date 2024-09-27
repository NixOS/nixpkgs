{ lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus
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

  cargoHash = "sha256-8w87h4ZKSMXUh4RRORhUBYDhuuG5GRkwl3Ho/u9PAig=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "xdotool-like for KDE Wayland";
    homepage = "https://github.com/jinliu/kdotool";
    license = licenses.asl20;
    maintainers = with maintainers; [ kotatsuyaki ];
  };
}

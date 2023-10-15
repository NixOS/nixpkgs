{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "pbpctrl";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "qzed";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-91sdlnffL/HX+Y8e6T+ZCa7MAcf4fWE0NJGLgmK47o8=";
  };

  cargoHash = "sha256-U4//GvAEhrfOrivwW/6PbKHdWXGIuilPl7Zo17wnwDY=";

  nativeBuildInputs = [ pkg-config protobuf ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "Control Google Pixel Buds Pro from the Linux command line.";
    homepage = "https://github.com/qzed/pbpctrl";
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.vanilla ];
    platforms = platforms.linux;
  };
}

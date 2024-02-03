{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "pbpctrl";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "qzed";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-tOdKXYfeO+HsYIDDU3fDb76ytRHVOcIqffEjFnLwOTI=";
  };

  cargoHash = "sha256-yP4tsXCAPE1KUDU5oBIejL4kACK1dNXK7Kmw37VMexM=";

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

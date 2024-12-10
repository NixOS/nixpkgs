{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "pbpctrl";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "qzed";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-V7wfEXJ0tVQNsi1OFU1Dk2d9ImsNFRriGutpJzh2tV8=";
  };

  cargoHash = "sha256-8D+WD5bOxoUhw4a7SUr+D2gn1NA7OkmoCcALO9HY8Qk=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "Control Google Pixel Buds Pro from the Linux command line";
    homepage = "https://github.com/qzed/pbpctrl";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ maintainers.vanilla ];
    platforms = platforms.linux;
    mainProgram = "pbpctrl";
  };
}

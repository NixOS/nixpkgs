{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, udev
}:

rustPlatform.buildRustPackage rec{
  pname = "makima";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "cyber-sushi";
    repo = "makima";
    rev = "v${version}";
    hash = "sha256-uoUevsQo+BLKPwNGp7qC9wLAVTRMNiuo+wWDLRKECb0=";
  };

  cargoHash = "sha256-k7eelGCDnfYtyU6NAas22U3jlioIqQBZ4H63p30T+E0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = with lib; {
    description = "Linux daemon to remap and create macros for keyboards, mice and controllers";
    homepage = "https://github.com/cyber-sushi/makima";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ByteSudoer ];
    platforms = platforms.linux;
    mainProgram = "makima";
  };
}

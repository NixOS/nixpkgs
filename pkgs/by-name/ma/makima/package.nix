{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, udev
}:

rustPlatform.buildRustPackage rec{
  pname = "makima";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "cyber-sushi";
    repo = "makima";
    rev = "v${version}";
    hash = "sha256-Zhr8j1JWxjwUZ3fjXKUEaKp3T6/dekeAxUDys6eniMQ=";
  };

  cargoHash = "sha256-LdgS833MKJOEnUmfvnH/sWG9RrRMNwbe5gAgXTUYzh8=";

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

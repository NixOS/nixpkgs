{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, stdenv}:

rustPlatform.buildRustPackage rec {
  pname = "gotify-desktop";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = pname;
    rev = version;
    sha256 = "sha256-ISK1sI7NkXJBtuCkl5g8ffrGv5dYgzmpsmPTZmDAaMI=";
  };

  cargoHash = "sha256-QK2rzC9l+CiDv1+0NzR2x5B/5BYiY8KkLC2jxBdjXMU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Small Gotify daemon to send messages as desktop notifications";
    homepage = "https://github.com/desbma/gotify-desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bryanasdev000 genofire ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "gotify-desktop";
  };
}

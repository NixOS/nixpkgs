{ lib
, rustPlatform
, fetchFromGitHub
, libinput
, libxkbcommon
, mesa
, pango
, udev
}:

rustPlatform.buildRustPackage rec {
  pname = "jay";
  version = "unstable-2022-11-20";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = pname;
    rev = "09b4668a5363a6e93dfb8ba35b244835f4edb0f2";
    sha256 = "sha256-0IIzXY7AFTGEe0TzJVKOtTPUZee0Wz40yKgEWLeIYJw=";
  };

  cargoSha256 = "sha256-zSq6YBlm6gJXGlF9xZ8gWSTMewdNqrJzwP58a0x8QIU=";

  buildInputs = [
    libxkbcommon
    mesa
    pango
    udev
    libinput
  ];

  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "A Wayland compositor written in Rust";
    homepage = "https://github.com/mahkoh/jay";
    license = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
  };
}

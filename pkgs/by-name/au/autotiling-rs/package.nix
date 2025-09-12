{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "autotiling-rs";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "ammgws";
    repo = "autotiling-rs";
    rev = "v${version}";
    sha256 = "sha256-S/6LRQTHdPGZkmbTAb0ufNoXE1nD+rIQ2ASJ8jjFS3E=";
  };

  cargoHash = "sha256-riQ1nOs4fBj9y/jK0nS7Y85vMejLrKrEJzNnsQKkoeg=";

  meta = with lib; {
    description = "Autotiling for sway (and possibly i3)";
    homepage = "https://github.com/ammgws/autotiling-rs";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "autotiling-rs";
  };
}

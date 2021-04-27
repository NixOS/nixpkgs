{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "kile-wl";
  version = "unstable-2021-04-22";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = "kile";
    rev = "b97b9f1e5b33862b33918efaf23fd1c0c5d7058a";
    sha256 = "sha256-97qJd3o8nJt8IX5tyGWtAmJsIv5Gcw1xoBFwxAqk7I8=";
  };

  # Upstream has Cargo.lock gitignored
  cargoPatches = [ ./update-Cargo-lock.diff ];

  cargoSha256 = "sha256-TEgIiw/XTDUOe9K7agHWI86f88w+eDJ332V0CgNHtfo=";

  meta = with lib; {
    description = "A tiling layout generator for river";
    homepage = "https://gitlab.com/snakedye/kile";
    license = licenses.mit;
    platforms = platforms.linux; # It's meant for river, a wayland compositor
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}

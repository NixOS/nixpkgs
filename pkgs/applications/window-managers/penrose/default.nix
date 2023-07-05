{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cairo,
  glib,
  pango,
  xorg,
}:
rustPlatform.buildRustPackage rec {
  pname = "penrose";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "sminez";
    repo = "penrose";
    rev = version;
    hash = "sha256-PwUXcHgB9A30CuApFwetuFSxAhIpMALSOBIMkQGibGA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
    glib
    pango
    xorg.xmodmap # required for penrose keybindings
  ];

  meta = with lib; {
    description = "A library for writing an X11 tiling window manager";
    homepage = "https://github.com/sminez/penrose";
    license = licenses.mit;
    maintainers = with maintainers; [icy-thought];
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "rmpc";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mierak";
    repo = "rmpc";
    rev = "v${version}";
    hash = "sha256-g+yzW0DfaBhJKTikYZ8eqe4pX8nJvbpJ1xaZ3W/O/bo=";
  };

  cargoHash = "sha256-wFrHgB4wYGeXvfdGf4SJAAL8fE6dAKDLL51Ohmn+1HQ=";

  cargoPatches = [
    # Patch Cargo.lock to make rmpc compile with older versions of rustc
    # Remove when Rust 1.79.0 is in master
    ./Cargo.lock.patch
  ];

  patches = [
    # Fix release mode tests compilation issues
    # Remove when next rmpc version comes out
    (fetchpatch {
      url = "https://github.com/mierak/rmpc/commit/f12be6f606f5319523f41576e7c463b6008b9069.patch";
      hash = "sha256-4L/MrdC/ydTqnkt3qd5H8hLZimiqct6sOkEq8rJN0F4=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  meta = {
    changelog = "https://github.com/mierak/rmpc/releases/tag/${src.rev}";
    description = "TUI music player client for MPD with album art support via kitty image protocol";
    homepage = "https://mierak.github.io/rmpc/";
    license = lib.licenses.bsd3;
    longDescription = ''
      Rusty Music Player Client is a beautiful, modern and configurable terminal-based Music Player
      Daemon client. It was inspired by ncmpcpp and aims to provide an alternative with support for
      album art through kitty image protocol without any ugly hacks. It also features ranger/lf
      inspired browsing of songs and other goodies.
    '';
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "rmpc";
  };
}

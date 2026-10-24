# Qingjian input method (Linux): Rust server backend.
#
# The official qingjian repository (main, since 2026-09-29 / c08ae57) ships a
# complete Linux side:
#   - apps/linux/server    Rust server (workspace member; Cargo.lock pinned here)
#   - apps/linux/fcitx5    fcitx5 addon (CMake, built by the fcitx5-qingjian package)
#
# This package only builds/installs the server binary. The fcitx5 addon is
# packaged separately (fcitx5-qingjian) and the offline dictionary/sentence
# model data separately (qingjian-data); the NixOS module assembles all three.
{
  lib,
  rustPlatform,
  pkg-config,
  openssl,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  strictDeps = true;
  __structuredAttrs = true;
  pname = "qingjian-server";
  version = "0.1.5-unstable-2026-09-29";

  src = fetchFromGitHub {
    owner = "qingjian-team";
    repo = "qingjian";
    rev = "c08ae57cb88b6a4a46f4a5e9c1d6d11c5e69222e";
    hash = "sha256-OulZ8oizG1XzDGX4FCZxlS5Qe3ss73isoyXPgGQIeKY=";
  };

  # Pinned to the upstream Cargo.lock (workspace contains macOS-only crates that
  # do not compile on Linux; build only the linux server member).
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-text-0.19.0" = "sha256-c7DuyTTF5vkClCeGGIWBX4HAMecA+1RujvVA0fcTQRE=";
    };
  };

  # buildRustPackage reads cargo flags from the environment rather than passing
  # the same-named parameters through automatically.
  env = {
    cargoBuildFlags = "-p qingjian-linux-server";
    cargoTestFlags = "-p qingjian-linux-server";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "Local large-model Chinese input method server for Qingjian";
    longDescription = ''
      Qingjian (青简) is a Chinese input method with a local language model.
      This is the Rust server backend: it provides sentence composition, word
      selection and whole-sentence re-ranking over a Unix socket to the fcitx5
      addon (see fcitx5-qingjian). It loads its dictionary and sentence model
      from QINGJIAN_RESOURCES (or, when bundled with the data package, from
      share/qingjian/resources next to the executable).
    '';
    homepage = "https://github.com/qingjian-team/qingjian";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.aozora-wings ];
    platforms = lib.platforms.linux;
    mainProgram = "qingjian-linux-server";
  };
}

# Qingjian input method (Linux): fcitx5 addon.
#
# The addon connects to the qingjian-server binary over a Unix socket; it does
# not spawn the server itself (the NixOS module starts the server as a user
# systemd service). The offline data is provided by the qingjian-data package.
{
  lib,
  stdenv,
  cmake,
  pkg-config,
  fcitx5,
  nlohmann_json,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  strictDeps = true;
  __structuredAttrs = true;
  pname = "fcitx5-qingjian";
  version = "0.1.5-unstable-2026-09-29";

  src = fetchFromGitHub {
    owner = "qingjian-team";
    repo = "qingjian";
    rev = "c08ae57cb88b6a4a46f4a5e9c1d6d11c5e69222e";
    hash = "sha256-OulZ8oizG1XzDGX4FCZxlS5Qe3ss73isoyXPgGQIeKY=";
  };

  sourceRoot = "source/apps/linux/fcitx5";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fcitx5
    nlohmann_json
  ];

  cmakeFlags = [ "-DBUILD_TESTING=OFF" ];

  meta = {
    description = "Fcitx5 addon for the Qingjian input method";
    longDescription = ''
      Qingjian (青简) is a Chinese input method with a local language model.
      This is the fcitx5 addon: it forwards keystrokes to the qingjian-server
      backend over a Unix socket and renders candidates in the fcitx5 UI.
    '';
    homepage = "https://github.com/qingjian-team/qingjian";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.aozora-wings ];
    platforms = lib.platforms.linux;
  };
}

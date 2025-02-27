# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Lily Foster <lily@lily.flowers>
# Portions of this code are adapted from nixos-cosmic
# https://github.com/lilyinstarlight/nixos-cosmic
{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  bash,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cosmic-idle";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-idle";
    tag = "epoch-${version}";
    hash = "sha256-hORU+iMvWA4XMSWmzir9EwjpLK5vOLR8BgMZz+aIZ4U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iFR0kFyzawlXrWItzFQbG/tKGd3Snwk/0LYkPzCkJUQ=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-idle"
  ];

  postPatch = ''
    substituteInPlace src/main.rs --replace-fail '"/bin/sh"' '"${lib.getExe' bash "sh"}"'
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "unstable"
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    description = "Idle daemon for the COSMIC Desktop Environment";
    homepage = "https://github.com/pop-os/cosmic-idle";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-idle";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}

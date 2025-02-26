{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  pkg-config,
  just,
  glib,
  flatpak,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-store";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-store";
    tag = "epoch-${version}";
    hash = "sha256-ce7PaHBhRFUoujAS6j10XWbD2PxzK6XXIk/ENclT1iY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kPCE6F8/UsTJOmIjwxBLISk/Jhfljwa666WhXuKkkDE=";

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [
    just
    pkg-config
    libcosmicAppHook
  ];

  buildInputs = [
    glib
    flatpak
    openssl
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-store"
  ];

  env = {
    VERGEN_GIT_COMMIT_DATE = "2025-02-21";
    VERGEN_GIT_SHA = src.rev;
  };

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-store";
    description = "App Store for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      ahoneybun
      nyabinary
    ];
    platforms = lib.platforms.linux;
  };
}

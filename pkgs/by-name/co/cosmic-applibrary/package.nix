{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-applibrary";
  version = "0-unstable-2024-02-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applibrary";
    rev = "e214e9867876c96b24568d8a45aaca2936269d9b";
    hash = "sha256-fZxDRktiHHmj7X3e5VyJJMO081auOpSMSsBnJdhhtR8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WCS1jCfnanILXGLq96+FI0gM1o4FIJQtSgZg86fe86E=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-app-library"
  ];

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
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
    homepage = "https://github.com/pop-os/cosmic-applibrary";
    description = "Application Template for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nyabinary ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-app-library";
  };
}
